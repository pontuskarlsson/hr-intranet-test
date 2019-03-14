module Refinery
  module CustomLists
    module Admin
      class CustomListsController < ::Refinery::AdminController

        crudify :'refinery/custom_lists/custom_list'

        def custom_list_params
          params.require(:custom_list).permit(:title, :position)
        end
      end
    end
  end
end
