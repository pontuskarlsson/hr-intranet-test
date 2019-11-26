module Refinery
  module Shipping
    class Cost < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_costs'

      TYPES = %w(domestic_transportation duty forwarding_fee freight_cost terminal_fee other)
      CURRENCIES = %w()

      belongs_to :shipment

      configure_enumerables :cost_type, TYPES

      validates :shipment_id,     presence: true
      validates :cost_type,       inclusion: TYPES

    end
  end
end
