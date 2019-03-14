module Refinery
  module Store
    module Admin
      class OrdersController < ::Refinery::AdminController

        crudify :'refinery/store/order',
                :title_attribute => 'order_number'

        def order_params
          params.require(:order).permit(
              :order_number, :reference, :total_price, :user_id, :status, :position, :retailer_id
          )
        end
      end
    end
  end
end
