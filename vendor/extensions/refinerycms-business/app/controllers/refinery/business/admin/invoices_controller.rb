module Refinery
  module Business
    module Admin
      class InvoicesController < ::Refinery::AdminController

        crudify :'refinery/business/invoice',
                :title_attribute => 'invoice_number',
                order: 'invoice_number ASC'

        def invoice_params
          params.require(:invoice).permit(
              :account_id, :invoice_id, :contact_id, :invoice_number, :invoice_type,
              :reference, :invoice_url, :invoice_date, :due_date, :status, :total_amount,
              :amount_due, :amount_paid, :amount_credited, :currency_code, :currency_rate,
              :updated_date_utc, :company_id, :company_label, :project_id, :project_label,
              :from_company_id, :from_company_label, :from_contact_id, :to_company_id,
              :to_company_label, :to_contact_id
          )
        end

      end
    end
  end
end
