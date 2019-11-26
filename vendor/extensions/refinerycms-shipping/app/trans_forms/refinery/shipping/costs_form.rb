module Refinery
  module Shipping
    class CostsForm < ApplicationTransForm
      set_main_model :shipment

      attribute :costs_attributes, Hash

      delegate :persisted?, :costs, to: :shipment

      validates :shipment, presence: true

      transaction do
        each_nested_hash_for costs_attributes do |attr|
          update_cost! attr
        end
      end

      protected

      def update_cost!(attr, allowed = %w(cost_type comments currency_code amount))
        if attr['id'].present?
          cost = find_from! shipment.costs, attr['id']
          if attr['_destroy'] == '1'
            cost.destroy
          else
            cost.attributes = attr.slice(*allowed)
            cost.save!
          end
        elsif attr['amount'].present?
          cost = shipment.costs.build(attr.slice(*allowed))
          cost.save!
        end
      end

    end
  end
end
