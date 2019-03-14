module Refinery
  module Store
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/store/product',
                :title_attribute => 'product_number'

        def product_params
          params.require(:product).permit(
              :product_number, :name, :description, :measurement_unit, :price_amount, :image_id, :position, :retailer_id
          )
        end
      end
    end
  end
end
