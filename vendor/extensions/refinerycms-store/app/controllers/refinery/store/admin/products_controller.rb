module Refinery
  module Store
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/store/product',
                :title_attribute => 'product_number',
                :xhr_paging => true

      end
    end
  end
end
