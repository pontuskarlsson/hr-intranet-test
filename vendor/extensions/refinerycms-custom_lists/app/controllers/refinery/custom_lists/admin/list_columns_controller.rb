module Refinery
  module CustomLists
    module Admin
      class ListColumnsController < ::Refinery::AdminController

        crudify :'refinery/custom_lists/list_column'

        def list_column_params
          params.require(:list_column).permit(
              :custom_list_id, :title, :column_type, :position
          )
        end
      end
    end
  end
end
