module Refinery
  module Employees
    module Admin
      class LeaveOfAbsencesController < ::Refinery::AdminController

        crudify :'refinery/employees/leave_of_absence',
                :title_attribute => 'start_date',
                :xhr_paging => true,
                order: 'start_date DESC'

      end
    end
  end
end
