module Refinery
  module Employees
    class ApplyLeaveMailer < ActionMailer::Base

      def notification(to_user, leave_of_absence)
        @leave_of_absence = leave_of_absence
        mail :subject => "Apply for Leave: #{ leave_of_absence.employee.full_name }",
             :to => to_user.email,
             :from => "\"#{Refinery::Core.site_name}\" <#{ Refinery::Employees.mailer_from_address }>"
      end

    end
  end
end
