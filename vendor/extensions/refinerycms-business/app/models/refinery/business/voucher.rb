module Refinery
  module Business
    class Voucher < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_vouchers'

      STATUSES = %w(valid used expired)

      belongs_to :company
      belongs_to :line_item_sales_purchase,   class_name: 'LineItem'
      belongs_to :line_item_sales_discount,   class_name: 'LineItem'
      belongs_to :line_item_sales_move_from,  class_name: 'LineItem'
      belongs_to :line_item_prepay_move_to,   class_name: 'LineItem'
      belongs_to :line_item_prepay_move_from, class_name: 'LineItem'
      belongs_to :line_item_sales_move_to,    class_name: 'LineItem'

      validates :article_id,      presence: true
      validates :status,          inclusion: STATUSES


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
