module Refinery
  module Business
    class InvoiceItemsBuildForm < ApplicationTransForm

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
        # each_nested_hash_for(monthly_minimums_attributes).each_with_object({}) { |(attr, i), acc|
        #   if attr['article_label'].present?
        #     acc[attr['article_label']] ||= 0.0
        #   end
        # }

        #{ article_code: 'WORK-QC-DN-DAY', billable_qty }

        qty_per_article_code = invoice.billables.each_with_object({}) { |billable, acc|
          acc[billable.article_code] ||= 0.0

          if billable.is_base_unit?
            acc[billable.article_code] += billable.qty
          else
            raise ActiveRecord::ActiveRecordError, "cannot translate between billable units for #{billable.article_code}"
          end
        }

        allocated_vouchers_by_article_code = invoice.invoice_items.select(&:transaction_type_is_pre_payment?)

        qty_per_transaction = invoice.invoice_items.each_with_object({}) { |invoice_item, acc|
          if invoice_item.transaction_type.present?
            acc[invoice_item.transaction_type] ||= {}
            acc[invoice_item.transaction_type][invoice_item] ||= {}
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
