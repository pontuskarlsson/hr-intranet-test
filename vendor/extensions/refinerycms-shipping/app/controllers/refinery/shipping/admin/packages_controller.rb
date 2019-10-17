module Refinery
  module Shipping
    module Admin
      class PackagesController < ::Refinery::AdminController

        crudify :'refinery/shipping/package',
                :title_attribute => 'name',
                order: 'created_at DESC'

        def package_params
          params.require(:package).permit(
              :shipment_id, :name, :package_type, :total_packages, :length_unit,
              :package_length, :package_width, :package_height, :volume_unit,
              :package_volume, :weight_unit, :package_gross_weight, :package_net_weight
          )
        end

      end
    end
  end
end
