Refinery::Employees::LeaveOfAbsence.class_eval do

  # For some reason, the decorator seems to load twice. Add a workaround
  # until root cause is discovered

  unless respond_to?(:_sl_notif_added)
    after_create :notify_manager

    def notify_manager
      # Currently, this is static timezone for HK, this could be changed
      # to Office setting, when Employment Contract has more info than
      # only the country code
      if absence_type_id == ::Refinery::Employees::LeaveOfAbsence::TYPE_SICK_LEAVE
        if start_date == DateTime.now.in_time_zone(8).to_date
          recipients = [::Refinery::User.find_by_email('linda@happyrabbit.com'), employee.try(:reporting_manager).try(:user)].compact.uniq
          recipients.each do |user|
            ::Refinery::Employees::SickLeaveMailer.notification(user, self).deliver
          end
        end

      elsif absence_type[:apply] && status == ::Refinery::Employees::LeaveOfAbsence::STATUS_WAITING_FOR_APPROVAL

        recipients = [::Refinery::User.find_by_email('linda@happyrabbit.com'), employee.try(:reporting_manager).try(:user)].compact.uniq
        recipients.each do |user|
          ::Refinery::Employees::ApplyLeaveMailer.notification(user, self).deliver
        end
      end
    end
    handle_asynchronously :notify_manager

    class_attribute :_sl_notif_added
  end

end
