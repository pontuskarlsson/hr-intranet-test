Refinery::Employees::SickLeave.class_eval do

  # For some reason, the decorator seems to load twice. Add a workaround
  # until root cause is discovered

  unless respond_to?(:_sl_not_added)
    after_create do
      # Currently, this is static timezone for HK, this could be changed
      # to Office setting, when Employment Contract has more info than
      # only the country code
      if start_date == DateTime.now.in_time_zone(8).to_date

        Refinery::User.find_each do |user|
          if user.wants_notification_for?(employee)

            puts 'SENDING EMAIL TO '<<user.email

            ::Refinery::Employees::SickLeaveMailer.notification(user, self).deliver
          end
        end

      end
    end

    class_attribute :_sl_not_added
  end

end
