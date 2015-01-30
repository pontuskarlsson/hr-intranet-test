module Refinery
  module Employees
    module Admin
      class AnnualLeavesController < ::Refinery::AdminController

        crudify :'refinery/employees/annual_leave',
                :title_attribute => 'start_date',
                :xhr_paging => true,
                order: 'start_date DESC'

      end
    end
  end
end
