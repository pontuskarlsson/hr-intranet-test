module Refinery
  module Store
    class OrderItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_store_order_items'

      belongs_to :order
      belongs_to :product

      #attr_accessible :order_id, :product_id, :product_number, :quantity, :sub_total_price, :position, :comment, :price_per_item

      validates :order_id,        presence: true
      validates :product_id,      uniqueness: { scope: :order_id }, allow_nil: true
      validates :product_number,  presence: true
      validates :quantity,        numericality: { greater_than: 0 }
      validates :price_per_item,  numericality: { greater_than: 0 }

      before_validation do
        if product.present?
          self.product_number = product.product_number
          self.price_per_item = product.price_amount
          self.sub_total_price = price_per_item * quantity
        end
      end

    end
  end
end
