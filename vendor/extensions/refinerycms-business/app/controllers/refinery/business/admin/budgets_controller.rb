module Refinery
  module Business
    module Admin
      class BudgetsController < ::Refinery::AdminController
        skip_before_filter :verify_authenticity_token, only: [:import]

        crudify :'refinery/business/budget',
                :title_attribute => 'description',
                :xhr_paging => true,
                order: 'description ASC'

      end
    end
  end
end
