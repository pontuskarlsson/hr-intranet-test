module Refinery
  module Business
    class OrderItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_order_items'

      belongs_to :order, optional: true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:article_code, :description]

      configure_assign_by_label :order, class_name: '::Refinery::Business::Order'
      configure_label :description

      validates :order_id,      presence: true
      validates :order_item_id, uniqueness: true, allow_blank: true
      validates :ordered_qty,   numericality: true
      validates :shipped_qty,   numericality: true,   allow_nil: true
      validates :unit_price,    numericality: true

      before_save do
        self.line_item_number ||= (order.order_items.maximum(:line_item_number) || 0) + 1 if line_item_number.nil? or line_item_number.zero?
        self.total_cost = qty * unit_price
      end

      after_save do
        order.sum_total_cost!
      end

      def qty
        shipped_qty.nil? ? ordered_qty : shipped_qty
      end

    end
  end
end
