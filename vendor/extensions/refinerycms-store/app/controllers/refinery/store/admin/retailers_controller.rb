module Refinery
  module Store
    module Admin
      class RetailersController < ::Refinery::AdminController

        crudify :'refinery/store/retailer',
                :title_attribute => 'name',
                :xhr_paging => true

      end
    end
  end
end
