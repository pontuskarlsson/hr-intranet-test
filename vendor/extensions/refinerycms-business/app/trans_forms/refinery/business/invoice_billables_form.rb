module Refinery
  module Business
    class InvoiceBillablesForm < ApplicationTransForm
      set_main_model :invoice, class_name: '::Refinery::Business::Invoice', proxy: true

      attribute :non_invoiced_billables_attributes,     Hash

      def non_invoiced_billables
        @non_invoiced_billables ||= invoice.company.present? ? invoice.company.billables.where(invoice_id: nil).order(billable_date: :desc) : []
      end

      transaction do
        each_nested_hash_for non_invoiced_billables_attributes do |attr|
          if attr['invoice_id'].to_i == @invoice.id
            billable = find_from! non_invoiced_billables, attr['id']
            billable.invoice_id = invoice.id
            billable.save!
          end
        end
      end

      private

    end
  end
end
