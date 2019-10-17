module Refinery
  module Shipping
    module Admin
      class RoutesController < ::Refinery::AdminController

        crudify :'refinery/shipping/route',
                :title_attribute => 'shipment_id',
                order: 'shipment_id DESC'

        def route_params
          params.require(:route).permit(
              :shipment_id, :shipment_label, :location_id, :location_label, :route_type, :route_description,
              :status, :arrived_at, :departed_at, :prior_route_id, :prior_route_label, :final_destination
          )
        end

      end
    end
  end
end
