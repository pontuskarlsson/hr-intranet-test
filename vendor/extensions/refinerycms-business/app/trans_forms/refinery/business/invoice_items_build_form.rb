module Refinery
  module Business
    class InvoiceItemsBuildForm < ApplicationTransForm

      attribute :invoice_for_month,           Date, default: proc { |f| f.invoice&.invoice_for_month }
      attribute :plan_title,                  String, default: -> (f, _) { f.invoice&.plan_title }
      attribute :plan_description,            String, default: -> (f, _) { f.invoice&.plan_description }
      attribute :buyer_reference,             String, default: -> (f, _) { f.invoice&.buyer_reference }
      attribute :minimums_attributes, Hash

      attr_accessor :invoice

      attr_reader :minimum_charges

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

        article_codes = each_nested_hash_for(minimums_attributes).reduce([]) { |acc, (attr, i)|
          acc | Array(attr['article_label'].presence)
        }
        voucher_articles_by_code = Refinery::Business::Article.voucher.is_public.where(code: article_codes).each_with_object({}) { |a, acc| acc[a.code] = a }

        # Not valid unless an actual Voucher Article was found for each supplied row
        errors.add(:minimums_attributes, 'contains invalid article codes') unless voucher_articles_by_code.length == article_codes.length
      end

      def model=(model)
        self.invoice = model
      end

      def minimums
        if minimums_attributes.is_a?(Hash) && minimums_attributes.any?
          invoice.minimums(minimums_attributes.values)
        else
          invoice.minimums
        end
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
        set_minimum_charges!


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

          if billable.bill_other_company?
            if billable.bill_happy_rabbit?
              # ...
            else
              # ...
            end
          else
            allocate_billable! billable
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
          @closing_balance_by_code[charge.article_label] ||= 0
          @closing_balance_by_code[charge.article_label] += charge.unallocated

          issued_vouchers_for_charge, matching_items = charge.build_vouchers_for(invoice)

          issued_vouchers_for_charge.each do |voucher|
            issued_vouchers << voucher
          end

          matching_items.each_pair do |prepay_in, prepay_discount_in|
            matching_discounts(prepay_in) << prepay_discount_in
          end
        end


        # Time to add description items and set correct order
        #
        line_item_order = 0
        handled = []
        if invoice.invoice_for_month.present?
          handled << invoice.informative_item_per("- - - Monthly Invoice for period #{invoice.invoice_for_month.at_beginning_of_month.iso8601} - #{invoice.invoice_for_month.at_end_of_month.iso8601}", line_item_order: line_item_order += 1)
        end

        minimum_charges.each do |charge|
          if charge.qty > 0
            handled << invoice.informative_item_per(charge.informative_description, line_item_order: line_item_order += 1)
          end
        end

        # After initial plan description, we place all Sales transactions for work (non-vouchers)
        sales_purchases = invoice.invoice_items.select { |invoice_item| invoice_item.transaction_type_is_sales_purchase? && !invoice_item.article_is_voucher }
        if sales_purchases.any?
          # Add section header
          handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << invoice.informative_item_per("- - - Sales of Products and Services", line_item_order: line_item_order += 1)
          sales_purchases.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item

            Array(matching_discounts(invoice_item)).each do |discount_invoice_item|
              discount_invoice_item.line_item_order = line_item_order += 1
              handled << discount_invoice_item
            end
          end
        end

        handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("- - - Credits: Opening Balance", line_item_order: line_item_order += 1)
        @opening_balance_by_code.each do |code, balance|
          handled << invoice.informative_item_per("[#{code}] x #{balance}", line_item_order: line_item_order += 1)
        end

        # Then comes the Pre Pay Redeem
        prepay_outs = invoice.invoice_items.select(&:transaction_type_is_prepay_out?)
        if prepay_outs.any?
          # Add section header
          handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << invoice.informative_item_per("- - - Credits: Redeemed", line_item_order: line_item_order += 1)
          prepay_outs.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item

            Array(matching_discounts(invoice_item)).each do |discount_invoice_item|
              discount_invoice_item.line_item_order = line_item_order += 1
              handled << discount_invoice_item
            end
          end
        end

        # Then comes the Sales Offset
        prepay_ins = invoice.invoice_items.select(&:transaction_type_is_prepay_in?)
        if prepay_ins.any? # sales_offset.any? || pre_pay.any?
          # Add section header
          handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
          handled << invoice.informative_item_per("- - - Credits: Issued", line_item_order: line_item_order += 1)

          prepay_ins.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item

            Array(matching_discounts(invoice_item)).each do |discount_invoice_item|
              discount_invoice_item.line_item_order = line_item_order += 1
              handled << discount_invoice_item
            end
          end
        end

        handled << invoice.informative_item_per("- - -", line_item_order: line_item_order += 1)
        handled << invoice.informative_item_per("- - - Credits: Closing Balance", line_item_order: line_item_order += 1)
        @closing_balance_by_code.each do |code, balance|
          handled << invoice.informative_item_per("[#{code}] x #{balance}", line_item_order: line_item_order += 1)
        end

        # Any previously existing invoice items, that have not been added the to handled array, is no longer used
        # and can be removed
        #
        # Or this should not happen, so maybe raise an error if there is any items not handled?
        remaining = invoice.invoice_items.select { |invoice_item| !handled.include? invoice_item }
        #remaining.map(&:destroy!)
        raise 'Unhandled invoice items' if remaining.any?

        # We call :calculated_line_amount here, because :line_amount is not set until a before_save callback
        invoice.total_amount = invoice.invoice_items.reduce(0) { |acc, invoice_item| acc + invoice_item.calculated_line_amount.to_f }

        invoice.minimums = minimum_charges
        invoice.plan_opening_balance = @opening_balance_by_code.values.reduce(&:+) || 0
        invoice.plan_closing_balance = @closing_balance_by_code.values.reduce(&:+) || 0

        min_charges_qty = minimum_charges.reduce(0.0) { |acc, c| acc + c.qty }
        handled_qty = handled_billables.select(&:bill_own_company?).reduce(0.0) { |acc, b| acc + b.qty }
        invoice.plan_issued = [min_charges_qty, handled_qty - invoice.plan_opening_balance].max
        invoice.plan_redeemed = invoice.plan_closing_balance - invoice.plan_opening_balance - invoice.plan_issued

        invoice.save!

        issued_vouchers.map { |v|
          v.line_item_prepay_in = v.line_item_prepay_in
          v.line_item_prepay_discount_in = v.line_item_prepay_discount_in
          v.save!
        }

        redeemed_vouchers.map { |v|
          v.line_item_prepay_out = v.line_item_prepay_out
          v.line_item_prepay_discount_out = v.line_item_prepay_discount_out
          v.line_item_sales_purchase = v.line_item_sales_purchase
          v.line_item_sales_discount = v.line_item_sales_discount
          v.save!
        }

        handled_billables.map { |b|
          b.line_item_sales = b.line_item_sales
          b.line_item_discount = b.line_item_discount
          b.save!
        }
      end

      private

      def set_minimum_charges!
        @minimum_charges = each_nested_hash_for(minimums_attributes).each_with_object([]) do |(attr, i), acc|
          if attr['article_label'].present?
            qty             = attr['qty'].to_f
            base_amount     = attr['base_amount'].to_f
            discount_amount = attr['discount_amount'].to_f
            discount_amount = discount_amount * base_amount * 0.01 if attr['discount_type'] == 'percentage'
            discount_amount = discount_amount * -1 if discount_amount > 0

            acc << Refinery::Business::Charge.new(
                qty,
                attr['article_label'],
                base_amount,
                discount_amount,
                attr['discount_type'],
                )
          end
        end
      end

      def add_redeemed_charge(voucher)

      end

      def next_voucher_for(code)
        @next_voucher_for ||= invoice.company.vouchers.applicable_to(invoice).includes(:article)

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

      def matching_discounts(line_item)
        @matching_discounts ||= {}
        @matching_discounts[line_item] ||= []
        @matching_discounts[line_item]
      end

      # There should only be one sales item per item_code and unit amount
      def sales_purchase_per(article, unit_amount)
        invoice.invoice_items.detect do |invoice_item|
          invoice_item.transaction_type_is_sales_purchase? && invoice_item.item_code == article.code && invoice_item.unit_amount == unit_amount
        end || invoice.invoice_items.sales_purchase.build(item_code: article.code, description: article.name, unit_amount: unit_amount, quantity: 0.0)
      end

      def sales_discount_per(for_item, unit_amount)
        da = unit_amount && unit_amount > 0 ? unit_amount * -1 : unit_amount

        # We limit discounts to sales items with item_code present
        if unit_amount && unit_amount != 0 && for_item.item_code
          discount_item_code = "#{for_item.item_code}-DISC"
          description = "Discount: [#{discount_item_code}{base_amount:#{for_item.unit_amount}}] #{da}"

          invoice_item = invoice.invoice_items.detect do |invoice_item|
            invoice_item.transaction_type_is_sales_discount? && invoice_item.unit_amount == da && invoice_item.item_code == discount_item_code
          end

          return invoice_item if invoice_item.present?

          invoice_item = invoice.invoice_items.sales_discount.build(unit_amount: da, item_code: discount_item_code, quantity: 0.0, description: description)
          matching_discounts(for_item) << invoice_item

          invoice_item
        end
      end

      def allocate_billable!(billable)
        if (voucher = next_voucher_for billable.article_code).present?
          prepay_out = invoice.invoice_items.prepay_out.build(unit_amount: -voucher.base_amount, quantity: billable.qty)
          prepay_discount_out =
              unless voucher.discount_amount.to_d.zero?
                invoice.invoice_items.prepay_discount_out.build(unit_amount: -voucher.discount_amount, quantity: billable.qty)
              end
          matching_discounts(prepay_out) << prepay_discount_out unless prepay_discount_out.nil?

          sales_purchase = sales_purchase_per billable.article, voucher.base_amount
          sales_discount = sales_discount_per sales_purchase, prepay_discount_out&.unit_amount # Will return nil if discount_amount is 0

          voucher.line_item_prepay_out = prepay_out
          voucher.line_item_prepay_discount_out = prepay_discount_out
          voucher.line_item_sales_purchase = sales_purchase
          voucher.line_item_sales_discount = sales_discount

          sales_purchase.quantity += prepay_out.quantity
          sales_discount.quantity += prepay_discount_out.quantity unless prepay_discount_out.nil? || sales_discount.nil?

          billable.line_item_sales = sales_purchase

          redeemed_vouchers << voucher

          add_redeemed_charge voucher

        elsif (charge = minimum_charges.detect { |mc| mc.allocated_to?(billable.article_code, billable.qty) }).present? or
            (charge = minimum_charges.detect { |mc| mc.applicable_to?(billable.article_code) }).present?
          # Get a sales invoice item for the billable article code (not charge which is the voucher article)
          sales_purchase = sales_purchase_per billable.article, charge.base_amount
          sales_purchase.quantity += billable.qty
          billable.line_item_sales = sales_purchase

          if charge.discount_amount < 0
            discount = sales_discount_per sales_purchase, charge.discount_amount
            discount.quantity += billable.qty
            billable.line_item_discount = discount
          end

        elsif billable.article.sales_unit_price > 0
          sales_purchase = sales_purchase_per billable.article, billable.article.sales_unit_price
          sales_purchase.quantity += billable.qty.to_f
          billable.line_item_sales = sales_purchase

        else
          raise ActiveRecord::ActiveRecordError, "cannot determine price for article code #{billable.article_code}"
        end
      end

    end
  end
end
