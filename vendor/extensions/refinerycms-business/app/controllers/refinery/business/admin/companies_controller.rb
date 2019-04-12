module Refinery
  module Business
    module Admin
      class CompaniesController < ::Refinery::AdminController

        crudify :'refinery/business/company',
                :title_attribute => 'code',
                order: 'code ASC'

        def company_params
          params.require(:company).permit(
              :code, :contact_id, :contact_label, :name
          )
        end

      end
    end
  end
end
