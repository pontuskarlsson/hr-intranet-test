module Refinery
  module Business
    module Admin
      class SectionsController < ::Refinery::AdminController

        crudify :'refinery/business/section',
                :title_attribute => 'description',
                order: 'start_date DESC'

        def section_params
          params.require(:section).permit(
              :project_id, :project_label, :description, :start_date, :end_date, :section_type, :budgeted_resources
          )
        end

      end
    end
  end
end
