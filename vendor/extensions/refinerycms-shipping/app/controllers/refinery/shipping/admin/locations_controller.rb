module Refinery
  module Shipping
    module Admin
      class LocationsController < ::Refinery::AdminController
        crudify :'refinery/shipping/location',
                :title_attribute => 'name',
                order: 'name DESC'

        helper_method :timezones_source

        def location_params
          params.require(:location).permit(
              :name, :description, :owner_id, :owner_label, :location_type, :airport,
              :railport, :roadport, :seaport, :location_code, :iata_code, :icao_code, :street1, :street2, :city,
              :state, :postal_code, :country, :country_code, :timezone, :lat, :lng, :customs_district_code,
              :confirmed_at, :verified_at, :archived_at, :public
          )
        end

        def timezones_source
          ::ActiveSupport::TimeZone::MAPPING.keys.to_json.html_safe
        end

      end
    end
  end
end
