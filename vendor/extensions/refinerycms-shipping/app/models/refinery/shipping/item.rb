module Refinery
  module Shipping
    class Item < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_items'

      belongs_to :shipment
      belongs_to :order,          class_name: '::Refinery::Business::Order'
      belongs_to :order_item,     class_name: '::Refinery::Business::OrderItem'

      validates :shipment_id,     presence: true

    end
  end
end
