module Refinery
  module Business
    class InvoiceItemsBuildForm < ApplicationTransForm

      attribute :invoice_for_month,           Date, default: proc { |f| f.invoice&.invoice_for_month }
      attribute :monthly_minimums_attributes, Hash

      attr_accessor :invoice

      validates :invoice,       presence: true

      validate do
        if invoice.billables.where(article_id: nil).exists?
          errors.add(:invoice, 'all Billables must have Article Codes assigned')
        end
      end

      def model=(model)
        self.invoice = model
      end

      def monthly_minimums
        []
      end

      transaction do
        invoice.invoice_items.each(&:destroy!)
        invoice.reload

        invoice.invoice_for_month = invoice_for_month

        voucher_opening_balance = active_vouchers.invoice.company.vouchers.applicable_to(invoice).joins(:article).group("#{Refinery::Business::Article.table_name}.code").count

        #binding.pry
        #raise ActiveRecord::ActiveRecordError, 'rollback'

        # Build a list of monthly minimum of Voucher article codes, as well as keep track of the prices and
        # discounts for said Vouchers.
        #
        # Note that the same Voucher article codes can be submitted more than once, i.e. when there is one price
        # for 9 quantities and then another price for 1 last quantity. In this circumstance, we need to make
        # sure that we reach the total quantities for each Voucher article code occurrence and that the price
        # is correctly allocated.
        #
        # The question is what happens when the Billables exceed the sum of multiple monthly minimum
        # for the same Voucher article code, which price should apply to the additional Billables? For now,
        # we simply take the first occurrence and call that the primary price.
        #
        article_codes = each_nested_hash_for(monthly_minimums_attributes).reject { |(attr, i)|
          attr['article_label'].blank?
        }.reduce([]) { |acc, (attr, i)|
          acc << attr['article_label']
        }.uniq
        voucher_articles_by_code = Article.voucher.is_public.where(code: article_codes).each_with_object({}) { |a, acc| acc[a.code] = a }

        # Raises an error unless an actual Voucher Article was found for each supplied row
        raise ActiveRecord::RecordNotFound unless voucher_articles_by_code.length == article_codes.length

        # Build and array from each nested hash from monthly minimums and merge the article into it. This
        # is important so that we can use the Voucher Article to check which Work Articles it can be
        # applied to.
        monthly_minimum_articles = each_nested_hash_for(monthly_minimums_attributes).reject { |(attr, i)|
          attr['article_label'].blank?
        }.map { |(mma, i)|

          base_amount = mma['base_amount'].to_f
          discount_amount = mma['discount_amount'].to_f
          discount_amount = discount_amount * base_amount * 0.01 if mma['discount_type'] == 'percentage'
          discount_amount = discount_amount * -1 if discount_amount > 0

          mma.merge(
              'voucher_article' => voucher_articles_by_code[mma['article_label']],
              'remaining_minimum_qty' => mma['monthly_minimum_qty'].to_f,
              'base_amount_f' => base_amount,
              'discount_amount_f' => discount_amount,
          )
        }

        qty_per_article_code = invoice.billables.includes(:article).each_with_object({}) { |billable, acc|
          if acc[billable.article_code].nil?
            acc[billable.article_code] = {
                billable_qty: 0.0,
                monthly_minimums: monthly_minimum_articles.select { |mma|
                  mma['voucher_article'].applicable_to?(billable.article_code)
                },
                article: billable.article,
                voucher_qty: 0.0,
            }
          end

          if billable.is_base_unit?
            acc[billable.article_code][:billable_qty] += billable.qty
          else
            raise ActiveRecord::ActiveRecordError, "cannot translate between billable units for #{billable.article_code}"
          end
        }

        qty_per_article_code.each do |article_code, quantities|

          loop do
            break if quantities[:billable_qty] <= quantities[:voucher_qty]
            break if (voucher = next_voucher_for article_code).nil?

            pre_pay_from = invoice.invoice_items.pre_pay_redeem.build(unit_amount: -voucher.amount, quantity: 1.0)

            sales = sales_item_per quantities[:article], voucher.amount
            sales.quantity += pre_pay_from.quantity
            quantities[:voucher_qty] += pre_pay_from.quantity

            voucher.line_item_prepay_move_from = pre_pay_from
            voucher.line_item_sales_move_to = sales

            redeemed_vouchers << voucher
          end

          un_billed_qty = quantities[:billable_qty] - quantities[:voucher_qty]

          # If after applying vouchers, there are still billables left un-allocated...
          idx = 0
          loop do
            monthly_minimum = quantities[:monthly_minimums][idx]
            break if un_billed_qty <= 0 or monthly_minimum.nil?

            qty = monthly_minimum['remaining_minimum_qty']
            allocated_qty = [qty, un_billed_qty].min

            # base_amount = monthly_minimum['base_amount'].to_f
            # discount_amount = monthly_minimum['discount_type'] == 'percentage' ? monthly_minimum['discount_amount'].to_f * base_amount * 0.01 : monthly_minimum['discount_amount'].to_f
            # discount_amount = discount_amount * -1 if discount_amount > 0

            sales = sales_item_per quantities[:article], monthly_minimum['base_amount_f']
            sales.quantity += allocated_qty

            if monthly_minimum['discount_amount_f'] < 0
              discount = discount_item_per monthly_minimum['discount_amount_f']
              discount.quantity += allocated_qty
            end

            un_billed_qty -= allocated_qty
            monthly_minimum['remaining_minimum_qty'] -= allocated_qty

            idx += 1
          end

          # If after applying monthly minimums, there are still billables left, take the first (if multiple) from
          # the monthly minimum to act as primary price. But now we also need to be aware that the article code
          # might not have been listed in the monthly minimum at all, in case we need to default to standard article
          # sales price.
          if un_billed_qty > 0
            monthly_minimum = quantities[:monthly_minimums][0]
            article = quantities[:article]

            if monthly_minimum.present?
              base_amount = monthly_minimum['base_amount_f']
              discount_amount = monthly_minimum['discount_amount_f']
            else
              base_amount = article.sales_unit_price
              discount_amount = 0
            end

            sales_purchase = sales_item_per quantities[:article], base_amount
            sales_purchase.quantity += un_billed_qty

            if discount_amount < 0
              discount = discount_item_per discount_amount
              discount.quantity += un_billed_qty
            end
          end

        end

        # After having gone through all billables and allocated them, we now need to check
        # if there is anything out of the monthly minimum quantities, that remain and we need
        # to issue vouchers for.
        #
        monthly_minimum_articles.each do |monthly_minimum|
          if monthly_minimum['remaining_minimum_qty'] > 0
            if monthly_minimum['remaining_minimum_qty'].to_i != monthly_minimum['remaining_minimum_qty']
              raise ActiveRecord::ActiveRecordError, 'cannot issue partial vouchers (decimal quantities)'
            end

            base_amount = monthly_minimum['base_amount_f']
            discount_amount = monthly_minimum['discount_amount_f']
            amount = base_amount + discount_amount

            sales = sales_item_per monthly_minimum['voucher_article'], base_amount
            discount = discount_item_per discount_amount # Will return nil if discount_amount is 0
            sales_offset = sales_offset_item_per amount

            loop do
              pre_pay_to = invoice.invoice_items.pre_pay.build(unit_amount: amount, quantity: 1.0)

              issued_vouchers << invoice.company.vouchers.build(
                  article: monthly_minimum['voucher_article'],
                  line_item_sales_purchase: sales,
                  line_item_sales_discount: discount,
                  line_item_sales_move_from: sales_offset,
                  line_item_prepay_move_to: pre_pay_to,
                  base_amount: base_amount,
                  discount_type: monthly_minimum['discount_type'],
                  discount_amount: monthly_minimum['discount_type'] == 'fixed_amount' ? discount_amount : nil,
                  discount_percentage: monthly_minimum['discount_type'] == 'percentage' ? discount_amount * 0.01 : nil,
                  amount: amount,
                  currency_code: invoice.currency_code,
                  valid_from: invoice.invoice_for_month,
                  valid_to: invoice.invoice_for_month + 1.year - 1.day,
              )

              sales.quantity += pre_pay_to.quantity
              discount.quantity += pre_pay_to.quantity if discount.present?
              sales_offset.quantity += pre_pay_to.quantity

              monthly_minimum['remaining_minimum_qty'] -= pre_pay_to.quantity

              break if monthly_minimum['remaining_minimum_qty'] <= 0
            end
          end
        end

        # Time to add description items and set correct order
        #
        line_item_order = 0
        handled = []
        if invoice.invoice_for_month.present?
          handled << invoice.invoice_items.build(description: "Monthly Invoice for period #{invoice.invoice_for_month.at_beginning_of_month.iso8601} - #{invoice.invoice_for_month.at_end_of_month.iso8601}", line_item_order: line_item_order += 1)
        end

        monthly_minimum_articles.each do |mma|
          handled << invoice.invoice_items.build(description: "#{mma['monthly_minimum_qty']} x [#{mma['voucher_article'].code}] @ #{mma['base_amount_f']}#{ mma['discount_amount_f'] < 0 ? " (#{mma['discount_amount_f']})" : '' }", line_item_order: line_item_order += 1)
        end

        # After initial plan description, we place all Sales transactions
        sales_work = invoice.invoice_items.select { |invoice_item| invoice_item.transaction_type_is_sales? && !invoice_item.article_is_voucher }
        discounts = invoice.invoice_items.select(&:transaction_type_is_discount?)
        if sales_work.any? || discounts.any?
          # Add section header
          handled << invoice.invoice_items.build(description: "- - -", line_item_order: line_item_order += 1)
          handled << invoice.invoice_items.build(description: "Sales of Products and Services", line_item_order: line_item_order += 1)
          sales_work.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
          discounts.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
        end

        handled << invoice.invoice_items.build(description: "- - -", line_item_order: line_item_order += 1)
        handled << invoice.invoice_items.build(description: "Credits: Opening Balance", line_item_order: line_item_order += 1)

        # Then comes the Pre Pay Redeem
        pre_pay_redeem = invoice.invoice_items.select(&:transaction_type_is_pre_pay_redeem?)
        if pre_pay_redeem.any?
          # Add section header
          handled << invoice.invoice_items.build(description: "- - -", line_item_order: line_item_order += 1)
          handled << invoice.invoice_items.build(description: "Previous Credits redeemed", line_item_order: line_item_order += 1)
          pre_pay_redeem.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
        end

        # Then comes the Sales Offset
        sales_voucher = invoice.invoice_items.select { |invoice_item| invoice_item.transaction_type_is_sales? && !invoice_item.article_is_voucher }
        sales_offset = invoice.invoice_items.select(&:transaction_type_is_sales_offset?)
        pre_pay = invoice.invoice_items.select(&:transaction_type_is_pre_pay?)
        if sales_offset.any? || pre_pay.any?
          # Add section header
          handled << invoice.invoice_items.build(description: "- - -", line_item_order: line_item_order += 1)
          handled << invoice.invoice_items.build(description: "New Credit issued for remaining balance", line_item_order: line_item_order += 1)
          sales_voucher.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
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

        handled << invoice.invoice_items.build(description: "- - -", line_item_order: line_item_order += 1)
        handled << invoice.invoice_items.build(description: "Credits: Closing Balance", line_item_order: line_item_order += 1)

        # Then comes anything else...
        remaining = invoice.invoice_items.select { |invoice_item| !handled.include? invoice_item }
        if remaining.any?
          # Add section header
          handled << invoice.invoice_items.build(description: "- - -", line_item_order: line_item_order += 1)
          remaining.each do |invoice_item|
            invoice_item.line_item_order = line_item_order += 1
            handled << invoice_item
          end
        end

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
      end

      private

      def next_voucher_for(code)
        @next_voucher_for ||= invoice.company.vouchers.active.includes(:article)
        next_voucher = @next_voucher_for.detect { |v| v.article_applicable_to? code }
        @next_voucher_for -= [next_voucher] if next_voucher.present?
        next_voucher
      end

      def issued_vouchers
        @issued_vouchers ||= []
      end

      def redeemed_vouchers
        @redeemed_vouchers ||= []
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

      def discount_item_per(unit_amount)
        da = unit_amount > 0 ? unit_amount * -1 : unit_amount
        if unit_amount != 0
          invoice.invoice_items.detect do |invoice_item|
            invoice_item.transaction_type == 'discount' && invoice_item.unit_amount == da
          end || invoice.invoice_items.build(transaction_type: 'discount', unit_amount: da, quantity: 0.0)
        end
      end

    end
  end
end
