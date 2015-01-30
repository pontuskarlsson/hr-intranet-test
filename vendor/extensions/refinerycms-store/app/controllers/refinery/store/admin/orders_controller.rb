module Refinery
  module Store
    module Admin
      class OrdersController < ::Refinery::AdminController

        crudify :'refinery/store/order',
                :title_attribute => 'order_number',
                :xhr_paging => true

      end
    end
  end
end
