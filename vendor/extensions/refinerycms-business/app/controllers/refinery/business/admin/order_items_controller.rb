module Refinery
  module Business
    module Admin
      class OrderItemsController < ::Refinery::AdminController

        crudify :'refinery/business/order_item',
                :title_attribute => 'description',
                order: 'description ASC'

        def order_item_params
          params.require(:order_item).permit(
              :order_id, :order_label, :order_item_id, :line_item_number, :article_id, :article_code,
              :description, :ordered_qty, :shipped_qty, :qty_unit, :unit_price, :discount,
              :total_cost, :account
          )
        end

      end
    end
  end
end
