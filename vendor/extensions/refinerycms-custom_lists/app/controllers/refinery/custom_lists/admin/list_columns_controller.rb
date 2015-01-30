module Refinery
  module CustomLists
    module Admin
      class ListColumnsController < ::Refinery::AdminController

        crudify :'refinery/custom_lists/list_column',
                :xhr_paging => true

      end
    end
  end
end
