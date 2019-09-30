module Refinery
  module Business
    module Admin
      class OrdersController < ::Refinery::AdminController

        crudify :'refinery/business/order',
                :title_attribute => 'description',
                order: 'description ASC'

        def order_params
          params.require(:order).permit(
              :order_id, :buyer_id, :buyer_label, :seller_id, :seller_label, :project_id, :project_label,
              :order_number, :order_type, :order_date, :version_number, :revised_date,
              :reference, :description, :delivery_date, :delivery_address, :delivery_instructions,
              :ship_mode, :shipment_terms, :attention_to, :status,
              :proforma_invoice_label, :invoice_label, :ordered_qty, :shipped_qty,
              :qty_unit, :currency_code, :total_cost, :account, :updated_date_utc
          )
        end

      end
    end
  end
end
