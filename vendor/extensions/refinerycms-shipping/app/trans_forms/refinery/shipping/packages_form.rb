module Refinery
  module Shipping
    class PackagesForm < ApplicationTransForm

      PACKAGE_ATTR = %w(name package_type total_packages package_length package_width package_height length_unit
                        package_volume volume_unit package_gross_weight package_net_weight weight_unit package_order)

      set_main_model :shipment

      attribute :packages_attributes, Hash

      delegate :persisted?, :packages, to: :shipment

      validates :shipment, presence: true

      transaction do
        each_nested_hash_for packages_attributes do |attr|
          update_package! attr
        end

        shipment.attributes = shipment.packages.select(&:persisted?).each_with_object(
            { no_of_parcels: 0.0, gross_weight_amount: 0.0, net_weight_amount: 0.0 }
        ) { |package, acc|
          acc[:no_of_parcels]       += package.total_packages
          acc[:gross_weight_amount] += package.package_gross_weight * package.total_packages
          acc[:net_weight_amount]   += package.package_net_weight * package.total_packages
        }
        shipment.save!
      end

      protected

      def update_package!(attr, allowed = PACKAGE_ATTR)
        if attr['id'].present?
          package = find_from! shipment.packages, attr['id']
          if attr['_destroy'] == '1'
            package.destroy
          else
            package.attributes = attr.slice(*allowed)
            package.save!
          end
        elsif attr['package_type'].present?
          package = shipment.packages.build(attr.slice(*allowed))
          package.save!
        end
      end

    end
  end
end
