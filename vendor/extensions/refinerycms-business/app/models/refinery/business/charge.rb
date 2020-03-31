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
        unit_amount * qty.to_f
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
        allocated + quantity <= qty && !!(@_allocated_qty += quantity)
      end

      def allocated
        @_allocated_qty ||= 0.0
      end

      def unallocated
        qty - allocated
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
    end
  end
end
