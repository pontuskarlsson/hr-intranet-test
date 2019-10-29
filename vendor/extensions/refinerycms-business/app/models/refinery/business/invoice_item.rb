module Refinery
  module Business
    class InvoiceItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoice_items'

      belongs_to :invoice

      validates :invoice_id,      presence: true
      validates :line_item_id,    uniqueness: true, allow_blank: true


      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.line_items.maximum(:line_item_order) || 0) + 1
        end
      end

      def label
        description
      end

    end
  end
end
