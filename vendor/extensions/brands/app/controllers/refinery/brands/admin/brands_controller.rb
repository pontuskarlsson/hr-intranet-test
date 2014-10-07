module Refinery
  module Brands
    module Admin
      class BrandsController < ::Refinery::AdminController

        crudify :'refinery/brands/brand',
                :title_attribute => 'name',
                :xhr_paging => true,
                order: 'name ASC'

      end
    end
  end
end
