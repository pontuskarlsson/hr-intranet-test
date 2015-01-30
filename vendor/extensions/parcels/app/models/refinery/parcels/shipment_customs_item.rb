module Refinery
  module Parcels
    class ShipmentCustomsItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_parcels_shipment_customs_items'

      belongs_to :shipment


    end
  end
end
