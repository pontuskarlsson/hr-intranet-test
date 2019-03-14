module Refinery
  module Calendar
    module Admin
      class VenuesController < ::Refinery::AdminController

        crudify :'refinery/calendar/venue',
                :title_attribute => 'name',
                :sortable => false,
                :order => 'created_at DESC'

        def venues_params
          params.require(:venue).permit(
              :name, :address, :url, :phone, :position
          )
        end
      end
    end
  end
end
