module Refinery
  module Business
    module Admin
      class BudgetsController < ::Refinery::AdminController
        skip_before_action :verify_authenticity_token, only: [:import]

        crudify :'refinery/business/budget',
                :title_attribute => 'description',
                order: 'description ASC'

        def budget_params
          params.require(:budget).permit(
              :description, :position, :customer_name, :from_date, :to_date,
              :no_of_products, :no_of_skus, :price, :quantity, :margin, :comments
          )
        end

      end
    end
  end
end
