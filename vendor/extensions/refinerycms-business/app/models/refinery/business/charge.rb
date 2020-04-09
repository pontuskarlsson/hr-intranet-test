module Refinery
  module Business
    class Charge < Struct.new(:qty, :article_label, :base_amount, :discount_amount, :discount_type)
      def article
        @article ||= Article.find_by_label(article_label) || raise(ActiveRecord::RecordNotFound)
      end

      def article_name
        article.name
      rescue ::ActiveRecord::RecordNotFound => e
        'N/A'
      end

      def unit_amount
        # Discount amount is a negative value so we add it when calculating total_amount
        base_amount.to_f + discount_amount.to_f
      end

      def total_amount
        unit_amount * qty.to_d
      end

      def persisted?
        false
      end

      def allocated_to?(article_code, quantity)
        applicable_to?(article_code) && allocate!(quantity)
      end

      def applicable_to?(article_code)
        article_label == article_code || article.applicable_to?(article_code)
      end

      def allocate!(quantity)
        allocated + quantity <= qty.to_d && !!(@_allocated_qty += quantity)
      end

      def allocated
        @_allocated_qty ||= 0.0
      end

      def unallocated
        qty.to_d - allocated
      end

      def informative_description
        "[#{article_label}] x #{qty} @ #{base_amount}#{discount_amount < 0 ? " (#{discount_amount})" : '' }"
      end

      def allocate_additional(quantity)
        @_additional_qty ||= 0.0
        @_additional_qty += quantity
      end

      def additional_qty
        @_additional_qty ||= 0.0
      end

      def total_additional_amount
        unit_amount * additional_qty.to_f
      end

      def discount_item_code
        "#{article_label}-DISC"
      end

      # === build_vouchers_for
      #
      # A method that takes an invoice and builds the necessary InvoiceItems to
      # on it to issue Vouchers for the remaining unallocated quantity.
      #
      # === Returns
      #
      # An array where the first index is an array with the issued vouchers and
      # the second index is a hash mapping the PrepayIn items with the correct
      # PrepayDiscountIn items (if present).
      #
      # Common practice assignment would look like this
      #
      #   @issued_vouchers, @matching_items = @charge.build_vouchers_for(@invoice)
      #
      def build_vouchers_for(invoice)
        issued_vouchers = []
        matching_discounts = {}

        if unallocated > 0
          if unallocated != unallocated.to_i
            raise ActiveRecord::ActiveRecordError, 'cannot issue partial vouchers (decimal quantities)'
          end

          loop do
            break unless allocate!(1.0)

            prepay_in = invoice.invoice_items.prepay_in.build(unit_amount: base_amount, item_code: article_label, quantity: 1.0)
            prepay_discount_in = discount_amount.to_d.zero? ? nil : invoice.invoice_items.prepay_discount_in.build(unit_amount: discount_amount, item_code: discount_item_code, quantity: 1.0)

            matching_discounts[prepay_in] = prepay_discount_in unless prepay_discount_in.nil?

            valid_from = invoice.invoice_for_month || invoice.invoice_date

            issued_vouchers << invoice.company.vouchers.build(
                article: article,
                line_item_prepay_in: prepay_in,
                line_item_prepay_discount_in: prepay_discount_in,
                base_amount: base_amount,
                discount_type: discount_type,
                discount_amount: discount_type == 'fixed_amount' ? discount_amount : nil,
                discount_percentage: discount_type == 'percentage' ? discount_amount * 0.01 : nil,
                amount: unit_amount,
                currency_code: invoice.currency_code,
                valid_from: valid_from,
                valid_to: valid_from + 1.year - 1.day,
                source: 'invoice',
            )
          end
        end

        [issued_vouchers, matching_discounts]
      end
    end
  end
end
