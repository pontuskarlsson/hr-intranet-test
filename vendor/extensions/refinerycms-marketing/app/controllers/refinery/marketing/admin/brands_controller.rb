module Refinery
  module Marketing
    module Admin
      class BrandsController < ::Refinery::AdminController

        crudify :'refinery/marketing/brand',
                :title_attribute => 'name',
                order: 'name ASC'

        def brand_params
          params.require(:brand).permit(
              :name, :website, :logo_id, :description, :position
          )
        end
      end
    end
  end
end
