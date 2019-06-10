module Refinery
  module Business
    module Admin
      class CompaniesController < ::Refinery::AdminController

        crudify :'refinery/business/company',
                :title_attribute => 'code',
                order: 'code ASC'

        def company_params
          params.require(:company).to_unsafe_h.slice('code', 'company_users_attributes', 'name', 'contact_id', 'contact_label')
        end

      end
    end
  end
end
