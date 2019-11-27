module Refinery
  module Shipping
    class CostsForm < ApplicationTransForm

      PROXY_ATTR = %w(rate_currency)
      COST_ATTR = %w(cost_type comments currency_code amount invoice_amount)

      set_main_model :shipment, proxy: { attributes: PROXY_ATTR }, class_name: '::Refinery::Shipping::Shipment'

      attribute :costs_attributes, Hash
      attribute :total_cost_manual_amount, Decimal

      delegate :persisted?, :costs, :total_cost_amount, to: :shipment

      validates :shipment, presence: true

      transaction do
        each_nested_hash_for costs_attributes do |attr|
          update_cost! attr
        end
      end

      protected

      def update_cost!(attr, allowed = COST_ATTR)
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
