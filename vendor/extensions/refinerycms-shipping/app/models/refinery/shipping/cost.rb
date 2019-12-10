module Refinery
  module Shipping
    class Cost < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_costs'

      TYPES = %w(domestic_transportation duty forwarding_fee freight_cost terminal_fee vat other)

      belongs_to :shipment, optional: true

      configure_enumerables :cost_type, TYPES

      validates :shipment_id,     presence: true
      validates :cost_type,       inclusion: TYPES
      validates :currency_code,   inclusion: Refinery::Shipping::Shipment::CURRENCIES

    end
  end
end
