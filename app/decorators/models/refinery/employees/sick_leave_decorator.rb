Refinery::Employees::SickLeave.class_eval do

  # For some reason, the decorator seems to load twice. Add a workaround
  # until root cause is discovered

  unless respond_to?(:_sl_notif_added)
    after_create :notify_other_employees

    def notify_other_employees
      # Currently, this is static timezone for HK, this could be changed
      # to Office setting, when Employment Contract has more info than
      # only the country code
      if start_date == DateTime.now.in_time_zone(8).to_date

        ::Refinery::Employees::Employee.current.each do |e|
          if e.user.wants_notification_for?(employee)
            ::Refinery::Employees::SickLeaveMailer.notification(e.user, self).deliver
          end
        end

      end
    end
    handle_asynchronously :notify_other_employees


    class_attribute :_sl_notif_added
  end

end
