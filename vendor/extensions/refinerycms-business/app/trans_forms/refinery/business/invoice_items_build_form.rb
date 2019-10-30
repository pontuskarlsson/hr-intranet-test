module Refinery
  module Business
    class InvoiceItemsBuildForm < ApplicationTransForm

      attribute :monthly_minimums_attributes, Hash
      # attribute :article_label,               String
      # attribute :monthly_minimum,             Integer, default: 10


      attr_accessor :invoice

      validates :invoice,       presence: true

      def model=(model)
        self.invoice = model
      end

      def monthly_minimums
        []
      end

      transaction do
        qty_per_article_code = invoice.billables.each_with_object({}) { |billable, acc|
          acc[billable.article_code] ||= { qty: 0.0, unit: billable.qty_unit }
          if billable.qty_unit == acc[billable.article_code][:qty]
            acc[billable.article_code][:qty] += billable.qty
          else
            raise ActiveRecord::ActiveRecordError, "cannot translate between billable units for #{billable.article_code}"
          end
        }

        qty_per_article_code.each_pair do |article_code, qty_and_unit|
          handle_vouchers_for article_code, qty_and_unit[:qty], qty_and_unit[:unit]
        end
      end

      private


      def handle_vouchers_for(article_code, qty, unit)

      end

      def active_vouchers
        @active_vouchers ||= invoice.company.vouchers.active.includes(:article)
      end

    end
  end
end
