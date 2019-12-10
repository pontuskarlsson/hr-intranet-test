module Refinery
  module Shipping
    class Item < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_items'

      belongs_to :shipment
      belongs_to :order,          class_name: '::Refinery::Business::Order', optional: true
      belongs_to :order_item,     class_name: '::Refinery::Business::OrderItem', optional: true

      configure_assign_by_label :order, class_name: '::Refinery::Business::Order'

      validates :shipment_id,     presence: true

    end
  end
end
