module Refinery
  module Business
    module Admin
      class PlansController < ::Refinery::AdminController

        crudify :'refinery/business/plan',
                :title_attribute => 'reference',
                order: 'reference ASC'

        def plan_params
          params.require(:plan).permit(
              :reference, :account_id, :company_id, :company_label, :title, :description, :currency_code,
              :start_date, :end_date, :status, :confirmed_at, :confirmed_by_id, :payment_terms_days,
              :notice_period_months, :min_contract_period_months, :notice_given_at, :notice_given_by_id,
              :contact_person_id, :contact_person_label, :account_manager_id, :account_manager_label,
              :payment_terms_type, :payment_terms_qty
          )
        end

      end
    end
  end
end
