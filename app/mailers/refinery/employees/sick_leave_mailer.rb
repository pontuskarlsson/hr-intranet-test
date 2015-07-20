module Refinery
  module Employees
    class SickLeaveMailer < ActionMailer::Base

      def notification(to_user, sick_leave)
        @sick_leave = sick_leave
        mail :subject => "Sick leave: #{ sick_leave.employee.full_name }",
             :to => to_user.email,
             :from => "\"#{Refinery::Core.site_name}\" <#{ Refinery::Parcels.mailer_from_address }>"
      end

    end
  end
end
