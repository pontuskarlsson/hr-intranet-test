module Refinery
  module Employees
    module Admin
      class SickLeavesController < ::Refinery::AdminController

        crudify :'refinery/employees/sick_leave',
                :title_attribute => 'start_date',
                :xhr_paging => true,
                order: 'start_date DESC'

      end
    end
  end
end
