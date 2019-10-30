module Refinery
  module Business
    class Voucher < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_vouchers'

      STATUSES = %w(active used expired)
      DISCOUNT_TYPES = %w(fixed_amount percentage)

      serialize :constraint, Hash

      belongs_to :company
      belongs_to :line_item_sales_purchase,   class_name: 'LineItem'
      belongs_to :line_item_sales_discount,   class_name: 'LineItem'
      belongs_to :line_item_sales_move_from,  class_name: 'LineItem'
      belongs_to :line_item_prepay_move_to,   class_name: 'LineItem'
      belongs_to :line_item_prepay_move_from, class_name: 'LineItem'
      belongs_to :line_item_sales_move_to,    class_name: 'LineItem'

      validates :article_id,      presence: true
      validates :status,          inclusion: STATUSES
      validates :discount_type,   inclusion: DISCOUNT_TYPES


      before_save do
        if invoice.present?
          self.line_item_order ||= (invoice.line_items.maximum(:line_item_order) || 0) + 1
        end
      end

      scope :active, -> { where(status: 'active') }

      def label
        description
      end

      def applies_to?(item_code)
        applies_to = constraint['applies_to'] || []
        applies_to.include? item_code
      end

    end
  end
end
