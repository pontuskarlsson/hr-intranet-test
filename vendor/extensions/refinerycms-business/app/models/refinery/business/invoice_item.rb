module Refinery
  module Business
    class InvoiceItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoice_items'

      TRANSACTION_TYPES = %w(sales discount pre_payment)

      belongs_to :invoice

      validates :invoice_id,        presence: true
      validates :line_item_id,      uniqueness: true, allow_blank: true
      validates :transaction_type,  inclusion: TRANSACTION_TYPES, allow_blank: true


      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.line_items.maximum(:line_item_order) || 0) + 1
        end
      end

      def label
        description
      end

      TRANSACTION_TYPES.each do |tt|
        define_method :"transaction_type_is_#{tt}?" do
          transaction_type == tt
        end
      end

    end
  end
end
