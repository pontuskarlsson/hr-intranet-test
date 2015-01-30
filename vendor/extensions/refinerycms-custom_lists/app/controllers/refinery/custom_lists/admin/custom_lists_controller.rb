module Refinery
  module CustomLists
    module Admin
      class CustomListsController < ::Refinery::AdminController

        crudify :'refinery/custom_lists/custom_list',
                :xhr_paging => true

      end
    end
  end
end
