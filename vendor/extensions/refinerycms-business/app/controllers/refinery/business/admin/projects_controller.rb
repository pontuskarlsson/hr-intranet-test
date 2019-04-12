module Refinery
  module Business
    module Admin
      class ProjectsController < ::Refinery::AdminController

        crudify :'refinery/business/project',
                :title_attribute => 'code',
                order: 'code ASC'

        def project_params
          params.require(:project).permit(
              :code, :company_id, :company_label, :description, :start_date, :end_date
          )
        end

      end
    end
  end
end
