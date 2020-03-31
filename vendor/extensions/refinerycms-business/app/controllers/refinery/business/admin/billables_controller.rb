module Refinery
  module Business
    module Admin
      class BillablesController < ::Refinery::AdminController

        crudify :'refinery/business/billable',
                :title_attribute => 'title',
                order: 'title ASC'

        def billable_params
          params.require(:billable).permit(
              :company_id, :company_label, :project_id, :project_label, :section_id,
              :invoice_id, :invoice_label, :billable_type, :status, :title, :description,
              :article_code, :qty, :qty_unit, :unit_price, :discount, :total_cost, :account,
              :billable_date, :assigned_to_id, :assigned_to_label, :archived_at, :bill_happy_rabbit,
              :billed_company_id, :billed_company_label, :billed_invoice_id, :billed_invoice_label
          )
        end

      end
    end
  end
end
