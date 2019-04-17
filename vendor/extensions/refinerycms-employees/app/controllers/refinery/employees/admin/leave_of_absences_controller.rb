module Refinery
  module Employees
    module Admin
      class LeaveOfAbsencesController < ::Refinery::AdminController

        crudify :'refinery/employees/leave_of_absence',
                :title_attribute => 'start_date',
                order: 'start_date DESC'

        def leave_of_absence_params
          params.require(:leave_of_absence).permit(
              :start_date, :start_half_day, :end_date, :end_half_day, :doctors_note_id, :employee_name,
              :absence_type_id, :absence_type_description, :status, :i_am_sick_today
          )
        end
      end
    end
  end
end
