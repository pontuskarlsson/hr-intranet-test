module Refinery
  module Shipping
    class Package < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_packages'

      TYPES = %w(Bag Bale Barrel Box Bulk Bundle Carton Crate Drum Package Pallet Roll)
      LENGTH_UNITS = %w(cm in)
      WEIGHT_UNITS = %w(kg lbs)

      belongs_to :shipment

      validates :shipment_id,     presence: true
      validates :package_type,    inclusion: TYPES

    end
  end
end
