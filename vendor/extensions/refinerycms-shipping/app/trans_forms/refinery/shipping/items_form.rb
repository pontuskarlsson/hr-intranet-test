module Refinery
  module Shipping
    class ItemsForm < ApplicationTransForm
      set_main_model :shipment

      attribute :items_attributes, Hash

      delegate :persisted?, :items, to: :shipment

      validates :shipment, presence: true

      transaction do
        each_nested_hash_for items_attributes do |attr|
          update_item! attr
        end
      end

      protected

      def update_item!(attr, allowed = %w(order_label hs_code_label))
        if attr['id'].present?
          item = find_from! shipment.items, attr['id']
          if attr['_destroy'] == '1'
            item.destroy
          else
            item.attributes = attr.slice(*allowed)
            item.save!
          end
        elsif attr['order_label'].present?
          item = shipment.items.build(attr.slice(*allowed))
          item.save!
        end
      end

    end
  end
end
