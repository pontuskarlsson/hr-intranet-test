module Refinery
  module Store
    module Admin
      class RetailersController < ::Refinery::AdminController

        crudify :'refinery/store/retailer',
                :title_attribute => 'name'

        def retailer_params
          params.require(:retailer).permit(
              :name, :default_price_unit, :position
          )
        end
      end
    end
  end
end
