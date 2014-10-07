module Refinery
  module Employees
    module Admin
      class EmployeesController < ::Refinery::AdminController

        crudify :'refinery/employees/employee',
                :title_attribute => 'employee_no',
                :xhr_paging => true,
                order: 'employee_no ASC'

      end
    end
  end
end
