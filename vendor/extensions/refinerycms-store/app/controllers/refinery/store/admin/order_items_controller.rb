module Refinery
  module Store
    module Admin
      class OrderItemsController < ::Refinery::AdminController

        crudify :'refinery/store/order_item',
                :title_attribute => 'product_number'

        def order_item_params
          params.require(:order_item).permit(
              :order_id, :product_id, :product_number, :quantity, :sub_total_price, :position, :comment, :price_per_item
          )
        end
      end
    end
  end
end
