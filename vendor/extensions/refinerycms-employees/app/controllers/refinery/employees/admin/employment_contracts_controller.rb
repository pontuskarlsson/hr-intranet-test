module Refinery
  module Employees
    module Admin
      class EmploymentContractsController < ::Refinery::AdminController

        crudify :'refinery/employees/employment_contract',
                :title_attribute => 'start_date',
                order: 'start_date DESC'

        def employment_contract_params
          params.require(:employment_contract).permit(
              :start_date, :end_date, :vacation_days_per_year, :employee_name, :country, :days_carried_over
          )
        end
      end
    end
  end
end
