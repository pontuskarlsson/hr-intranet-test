module Refinery
  module Business
    module Admin
      class NumberSeriesController < ::Refinery::AdminController

        crudify :'refinery/business/number_serie',
                :title_attribute => 'identifier',
                order: 'identifier ASC'

        def number_serie_params
          params.require(:number_serie).permit(
              :identifier, :last_counter, :prefix, :suffix, :number_of_digits
          )
        end

      end
    end
  end
end
