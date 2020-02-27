module Refinery
  module Business
    module Admin
      class NumberSeriesController < ::Refinery::AdminController

        crudify :'refinery/business/number_serie',
                :title_attribute => 'identifier',
                order: 'identifier ASC',
                :redirect_to_url => "refinery.business_admin_number_series_index_path"

        def number_serie_params
          params.require(:number_serie).permit(
              :identifier, :last_counter, :prefix, :suffix, :number_of_digits
          )
        end

      end
    end
  end
end
