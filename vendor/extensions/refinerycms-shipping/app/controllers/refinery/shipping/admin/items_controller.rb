module Refinery
  module Shipping
    module Admin
      class ItemsController < ::Refinery::AdminController

        crudify :'refinery/shipping/item',
                :title_attribute => 'order_label',
                order: 'created_at DESC'

        def item_params
          params.require(:item).permit(
              :shipment_id, :order_id, :order_label, :order_item_id, :article_code,
              :description, :hs_code_label, :partial_shipment, :qty
          )
        end

      end
    end
  end
end
