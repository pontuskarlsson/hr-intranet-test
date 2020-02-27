module Refinery
  module Marketing
    module Admin
      class ShowsController < ::Refinery::AdminController

        crudify :'refinery/marketing/show',
                :title_attribute => 'name',
                order: 'name ASC'

        def show_params
          params.require(:show).permit(
              :name, :website, :logo_id, :description, :position, :msg_json_struct
          )
        end

      end
    end
  end
end
