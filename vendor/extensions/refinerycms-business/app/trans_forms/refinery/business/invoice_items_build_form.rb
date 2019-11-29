module Refinery
  module Business
    class InvoiceItemsBuildForm < ApplicationTransForm

      attribute :invoice_for_month,           Date, default: proc { |f| f.invoice&.invoice_for_month }
      attribute :plan_title,                  String, default: -> (f, _) { f.invoice&.plan_title }
      attribute :plan_description,            String, default: -> (f, _) { f.invoice&.plan_description }
      attribute :buyer_reference,             String, default: -> (f, _) { f.invoice&.buyer_reference }
      attribute :minimums_attributes, Hash

      attr_accessor :invoice

      validates :invoice,           presence: true

      validate do
        if invoice.present?
          errors.add(:invoice, 'company is missing') unless invoice.company.present?
          errors.add(:invoice, 'is not managed') unless invoice.is_managed

          if invoice.billables.where(article_id: nil).exists?
            errors.add(:invoice, 'all Billables must have Article Codes assigned')
          end

          if each_nested_hash_for(minimums_attributes).any? { |(mma, i)| mma['article_label'].present? }
            errors.add(:invoice_for_month, 'must be present if minimums are present') unless invoice_for_month.present?
          else
            errors.add(:minimums_attributes, 'cannot be empty when there are no billables present') if invoice.billables.empty?
          end
        end
      end

      def model=(model)
        self.invoice = model
      end

      def minimums
        invoice.minimums
      end

      transaction do

        #
        # STEP 1
        #
        # Delete previous invoice items and set the basic Invoice attributes
        #
        invoice.invoice_items.each(&:destroy!)
        invoice.reload

        invoice.invoice_for_month = invoice_for_month
        invoice.plan_title = plan_title
        invoice.buyer_reference = buyer_reference
        invoice.plan_description = plan_description

        @opening_balance_by_code = invoice.company.vouchers.applicable_to(invoice).joins(:article).group("#{Refinery::Business::Article.table_name}.code").count
        @closing_balance_by_code = @opening_balance_by_code.dup


        #
        # STEP 2
        #
        # Build a list of minimum charges of Voucher article codes, as well as keep track of the prices and
        # discounts for said Vouchers.
        #
        # Note that the same Voucher article codes can be submitted more than once, i.e. when there is one price
        # for 9 quantities and then another price for 1 last quantity. In this circumstance, we need to make
        # sure that we reach the total quantities for each Voucher article code occurrence and that the price
        # is correctly allocated.
        #
        # The question is what happens when the Billables exceed the sum of multiple minimum charges
        # for the same Voucher article code, which price should apply to the additional Billables? For now,
        # we simply take the first occurrence and call that the primary price.
        #
        article_codes = each_nested_hash_for(minimums_attributes).reduce([]) { |acc, (attr, i)|
          acc | Array(attr['article_label'].presence)
        }
        voucher_articles_by_code = Refinery::Business::Article.voucher.is_public.where(code: article_codes).each_with_object({}) { |a, acc| acc[a.code] = a }

        # Raises an error unless an actual Voucher Article was found for each supplied row
        raise ActiveRecord::RecordNotFound unless voucher_articles_by_code.length == article_codes.length

        minimum_charges = each_nested_hash_for(minimums_attributes).each_with_object([]) do |(attr, i), acc|
          if attr['article_label'].present?
            qty             = attr['qty'].to_f
            base_amount     = attr['base_amount'].to_f
            discount_amount = attr['discount_amount'].to_f
            discount_amount = discount_amount * base_amount * 0.01 if attr['discount_type'] == 'percentage'
            discount_amount = discount_amount * -1 if discount_amount > 0

            acc << Refinery::Business::Invoice::Charge.new(
                qty,
                attr['article_label'],
                base_amount,
                discount_amount,
                attr['discount_type'],
            )
          end
        end


        #
        # STEP 3
        #
        # Go through each billable and create invoice items for them.
        #
        # First we try to allocate vouchers from the opening balance of credits.
        #
        # If no voucher could be used, we try to allocate the billable to the
        # minimum amounts.
        #
        # If all minimum amounts have been allocated, try to allocate additional
        # amounts to the first minimum that is applicable
        #
        # Lastly, if a billable is still un-allocated, add an additional charge
        # and allocate to that one
        #
        invoice.billables.includes(:article).each do |billable|
          if billable.is_base_unit?
            handled_billables << billable
          else
            raise ActiveRecord::ActiveRecordError, "cannot translate between billable units for #{billable.article_code}"
          end

          if (voucher = next_voucher_for billable.article_code).present?
            pre_pay_from = invoice.invoice_items.pre_pay_redeem.build(unit_amount: -voucher.amount, quantity: billable.qty)

            sales = sales_item_per billable.article, voucher.amount
            sales.quantity += pre_pay_from.quantity

            voucher.line_item_prepay_move_from = pre_pay_from
            voucher.line_item_sales_move_to = sales

            billable.line_item_sales = sales

            redeemed_vouchers << voucher

          elsif (charge = minimum_charges.detect { |mc| mc.allocated_to?(billable.article_code, billable.qty) }).present? or
                (charge = minimum_charges.detect { |mc| mc.applicable_to?(billable.article_code) }).present?
            # Get a sales invoice item for the billable article code (not charge which is the voucher article)
            sales = sales_item_per billable.article, charge.base_amount
            sales.quantity += billable.qty
            billable.line_item_sales = sales

            if charge.discount_amount < 0
              discount = discount_item_per sales, charge.discount_amount
              discount.quantity += billable.qty
              billable.line_item_discount = discount
            end

          elsif billable.article.sales_unit_price > 0
            sales = sales_item_per billable.article, billable.article.sales_unit_price
            sales.quantity += billable.qty.to_f
            billable.line_item_sales = sales

          else
            raise ActiveRecord::ActiveRecordError, "cannot determine price for article code #{billable.article_code}"
          end
        end


        #
        # STEP 4
        #
        # After having gone through all billables and allocated them, we now need to check
        # if there is anything out of the minimum quantities, that remain and we need
        # to issue vouchers for.
        #
        minimum_charges.each do |charge|
          if charge.unallocated > 0
            if charge.unallocated != charge.unallocated.to_i
              raise ActiveRecord::ActiveRecordError, 'cannot issue partial vouchers (decimal quantities)'
            end

            # Get a sales invoice item for the voucher article code
            sales = sales_item_per charge.article, charge.base_amount
            discount = discount_item_per sales, charge.discount_amount # Will return nil if discount_amount is 0
            sales_offset = sales_offset_item_per charge.unit_amount

            loop do
              break unless charge.allocate!(1.0)

              pre_pay_to = invoice.invoice_items.pre_pay.build(unit_amount: charge.unit_amount, quantity: 1.0)

              issued_vouchers << invoice.company.vouchers.build(
                  article: charge.article,
                  line_item_sales_purchase: sales,
                  line_item_sales_discount: discount,
                  line_item_sales_move_from: sales_offset,
                  line_item_prepay_move_to: pre_pay_to,
                  base_amount: charge.base_amount,
                  discount_type: charge.discount_type,
                  discount_amount: charge.discount_type == 'fixed_amount' ? charge.discount_amount : nil,
                  discount_percentage: charge.discount_type == 'percentage' ? charge.discount_amount * 0.01 : nil,
                  amount: charge.unit_amount,
                  currency_code: invoice.currency_code,
                  valid_from: invoice.invoice_for_month,
                  valid_to: invoice.invoice_for_month + 1.year - 1.day,
              )

              sales.quantity += pre_pay_to.quantity
              discount.quantity += pre_pay_to.quantity if discount.present?
              sales_offset.quantity += pre_pay_to.quantity

              @closing_balance_by_code[charge.article_label] ||= 0
              @closing_balance_by_code[charge.article_label] += pre_pay_to.quantity
            end
          end
        end


        # Time to add description items and set correct order
        #
        line_item_order = 0
        handled = []
        if invoice.invoice_for_month.present?
          handled << informative_item_per("- - - Monthly Invoice for period #{invoice.invoice_for_month.at_beginning_of_month.iso8601} - #{invoice.invoice_for_month.at_end_of_month.iso8601}", line_item_order: line_item_order += 1)
        end

        minimum_charges.each do |charge|
          if charge.qty > 0
            handled << informative_item_per(charge.informative_description, line_item_order: line_item_order += 1)
          end
        end

        # After initial plan description, we place all Sales transactions
        sales_work = invoice.invoice_items.select { |invoice_item| invoice_item.transaction_type_is_sales? && !invoice_item.article_is_voucher }
        if sales_work.any?
          # Add section header
          handled << informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << informative_item_per("- - - Sales of Products and Services", line_item_order: line_item_order += 1)
          sales_work.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
            all_discounts_for(invoice_item).each do |discount_invoice_item|
              discount_invoice_item.line_item_order = line_item_order += 1
              handled << discount_invoice_item
            end
          end
        end

        handled << informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << informative_item_per("- - - Credits: Opening Balance", line_item_order: line_item_order += 1)
        @opening_balance_by_code.each do |code, balance|
          handled << informative_item_per("[#{code}] x #{balance}", line_item_order: line_item_order += 1)
        end

        # Then comes the Pre Pay Redeem
        pre_pay_redeem = invoice.invoice_items.select(&:transaction_type_is_pre_pay_redeem?)
        if pre_pay_redeem.any?
          # Add section header
          handled << informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << informative_item_per("- - - Credits: Redeemed", line_item_order: line_item_order += 1)
          pre_pay_redeem.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
        end

        # Then comes the Sales Offset
        sales_voucher = invoice.invoice_items.select { |invoice_item| invoice_item.transaction_type_is_sales? && invoice_item.article_is_voucher }
        sales_offset = invoice.invoice_items.select(&:transaction_type_is_sales_offset?)
        pre_pay = invoice.invoice_items.select(&:transaction_type_is_pre_pay?)
        if sales_offset.any? || pre_pay.any?
          # Add section header
          handled << informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << informative_item_per("- - - Credits: Issued", line_item_order: line_item_order += 1)
          sales_voucher.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item

            all_discounts_for(invoice_item).each do |discount_invoice_item|
              discount_invoice_item.line_item_order = line_item_order += 1
              handled << discount_invoice_item
            end
          end
          sales_offset.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
          pre_pay.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
        end

        handled << informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << informative_item_per("- - - Credits: Closing Balance", line_item_order: line_item_order += 1)
        @closing_balance_by_code.each do |code, balance|
          handled << informative_item_per("[#{code}] x #{balance}", line_item_order: line_item_order += 1)
        end

        # Any previously existing invoice items, that have not been added the to handled array, is no longer used
        # and can be removed
        remaining = invoice.invoice_items.select { |invoice_item| !handled.include? invoice_item }
        remaining.map(&:destroy!)

        # We call :calculated_line_amount here, because :line_amount is not set until a before_save callback
        invoice.total_amount = invoice.invoice_items.reduce(0) { |acc, invoice_item| acc + invoice_item.calculated_line_amount.to_f }

        invoice.minimums = minimum_charges
        #invoice.additionals = additionals.values
        invoice.plan_opening_balance = @opening_balance_by_code.values.reduce(&:+) || 0
        invoice.plan_redeemed = redeemed_vouchers.count
        invoice.plan_issued = issued_vouchers.count
        invoice.plan_closing_balance = @closing_balance_by_code.values.reduce(&:+) || 0

        invoice.save!

        issued_vouchers.map { |v|
          v.line_item_sales_purchase = v.line_item_sales_purchase
          v.line_item_sales_discount = v.line_item_sales_discount
          v.line_item_sales_move_from = v.line_item_sales_move_from
          v.line_item_prepay_move_to = v.line_item_prepay_move_to
          v.save!
        }

        redeemed_vouchers.map { |v|
          v.line_item_prepay_move_from = v.line_item_prepay_move_from
          v.line_item_sales_move_to = v.line_item_sales_move_to
          v.save!
        }

        handled_billables.map { |b|
          b.line_item_sales = b.line_item_sales
          b.line_item_discount = b.line_item_discount
          b.save!
        }
      end

      private

      def next_voucher_for(code)
        @next_voucher_for ||= invoice.company.vouchers.active.includes(:article)

        if (next_voucher = @next_voucher_for.detect { |v| v.article_applicable_to? code }).present?
          @next_voucher_for -= [next_voucher]
          @closing_balance_by_code[next_voucher.article_code] -= 1
          next_voucher
        end
      end

      def issued_vouchers
        @issued_vouchers ||= []
      end

      def redeemed_vouchers
        @redeemed_vouchers ||= []
      end

      def handled_billables
        @handled_billables ||= []
      end

      # There should only be one sales item per item_code and unit amount
      def sales_item_per(article, unit_amount)
        invoice.invoice_items.detect do |invoice_item|
          invoice_item.transaction_type == 'sales' && invoice_item.item_code == article.code && invoice_item.unit_amount == unit_amount
        end || invoice.invoice_items.build(transaction_type: 'sales', item_code: article.code, description: article.name, unit_amount: unit_amount, quantity: 0.0)
      end

      def sales_offset_item_per(unit_amount)
        ua = unit_amount > 0 ? unit_amount * -1 : unit_amount
        invoice.invoice_items.detect do |invoice_item|
          invoice_item.transaction_type == 'sales_offset' && invoice_item.unit_amount == ua
        end || invoice.invoice_items.build(transaction_type: 'sales_offset', unit_amount: ua, quantity: 0.0)
      end

      def discount_item_per(for_item, unit_amount)
        da = unit_amount > 0 ? unit_amount * -1 : unit_amount

        # We limit discounts to sales items with item_code present
        if unit_amount != 0 && for_item.item_code
          description = "Discount: [#{for_item.item_code}{base_amount:#{for_item.unit_amount}}] #{da}"

          invoice.invoice_items.detect do |invoice_item|
            invoice_item.transaction_type == 'discount' && invoice_item.unit_amount == da && invoice_item.description == description
          end || invoice.invoice_items.build(transaction_type: 'discount', unit_amount: da, quantity: 0.0, description: description)
        end
      end

      def informative_item_per(description, attr = {})
        @matched_informatives ||= []

        # Match existing but not previously matched informative items
        item = invoice.invoice_items.detect do |invoice_item|
          !@matched_informatives.include?(invoice_item) && invoice_item.transaction_type.nil? && invoice_item.description == description
        end || invoice.invoice_items.build(attr.merge(description: description, transaction_type: nil))

        # Set attributes in case it was a previously existing item that should now have another line_item_order
        item.attributes = attr

        # Add to matched array so we don't re-assign the same one again
        @matched_informatives << item

        item
      end

      def all_discounts_for(for_item)
        description = "Discount: [#{for_item.item_code}{base_amount:#{for_item.unit_amount}}]"

        invoice.invoice_items.select do |invoice_item|
          invoice_item.transaction_type == 'discount' && invoice_item.description && invoice_item.description[description]
        end
      end

    end
  end
end
