module Refinery
  module Store
    module Admin
      class OrderItemsController < ::Refinery::AdminController

        crudify :'refinery/store/order_item',
                :title_attribute => 'product_number',
                :xhr_paging => true

      end
    end
  end
end
