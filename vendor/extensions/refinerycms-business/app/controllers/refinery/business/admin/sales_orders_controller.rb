module Refinery
  module Business
    module Admin
      class SalesOrdersController < ::Refinery::AdminController

        crudify :'refinery/business/sales_order',
                :title_attribute => 'order_ref',
                order: 'order_ref ASC'

        def sales_order_params
          params.require(:sales_order).permit(
              :order_ref, :company, :billing_address, :delivery_address,
              :modified_date, :total, :currency_name, :position
          )
        end

      end
    end
  end
end
