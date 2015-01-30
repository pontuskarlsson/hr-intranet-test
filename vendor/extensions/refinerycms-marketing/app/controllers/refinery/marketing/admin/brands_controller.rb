module Refinery
  module Marketing
    module Admin
      class BrandsController < ::Refinery::AdminController

        crudify :'refinery/marketing/brand',
                :title_attribute => 'name',
                :xhr_paging => true,
                order: 'name ASC'

      end
    end
  end
end
