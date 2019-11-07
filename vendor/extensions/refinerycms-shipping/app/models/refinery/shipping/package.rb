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
      
      validate do
        if shipment.present?
          errors.add(:length_unit, :invalid) unless shipment.length_unit == length_unit
          errors.add(:weight_unit, :invalid) unless shipment.weight_unit == weight_unit
        end
      end
      
      def total_gross_weight_amount
        package_gross_weight.to_f * total_packages.to_f
      end

      def total_net_weight_amount
        package_net_weight.to_f * total_packages.to_f
      end

    end
  end
end
