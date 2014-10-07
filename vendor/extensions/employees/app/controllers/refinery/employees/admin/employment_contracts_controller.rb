module Refinery
  module Employees
    module Admin
      class EmploymentContractsController < ::Refinery::AdminController

        crudify :'refinery/employees/employment_contract',
                :title_attribute => 'start_date',
                :xhr_paging => true,
                order: 'start_date DESC'

      end
    end
  end
end
