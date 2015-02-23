module Refinery
  module Employees
    class AnnualLeave < Refinery::Core::BaseModel
      self.table_name = 'refinery_annual_leaves'

      CALENDAR_FUNCTION = 'AnnualLeave'

      belongs_to :employee
      belongs_to :event,          class_name: '::Refinery::Calendar::Event', dependent: :destroy
      has_many :annual_leave_records,     dependent: :destroy

      attr_writer :employee_name
      attr_accessible :start_date, :start_half_day, :end_date, :end_half_day, :employee_name

      validates :employee_id,   presence: true
      validates :event_id,      uniqueness: true, allow_nil: true
      validates :start_date,    presence: true
      validate do
        if end_date.present?
          errors.add(:end_date) unless end_date > start_date
        end
      end

      before_validation do
        if @employee_name.present?
          if (employee = Employee.find_by_full_name(@employee_name)).present?
            self.employee = employee
          end
        end
      end

      before_save do
        unless event.present?
          # This creates a Calendar for the specific function of displaying Sick Leave events.
          calendar = ::Refinery::Calendar::Calendar.find_or_create_by_function!(CALENDAR_FUNCTION, { title: 'Annual Leave', private: false, activate_on_create: true })
          self.event = calendar.events.build
        end

        event.title = "AL: #{ employee.full_name }"
        event.excerpt = 'Annual Leave'
        event.starts_at = start_date.beginning_of_day  + (start_half_day ? 14.hours : 0)
        event.ends_at = end_date.present? ? (end_half_day   ? end_date.beginning_of_day + 14.hours : end_date.end_of_day) : nil

        event.save!
        self.event_id = event.id # Not getting associated without this line...

        if end_date.present?
          # We can calculate the entire leave

          # Start by retrieving all public holidays that are in between the starting and ending dates of
          # the leave and is not a half day. Those days should not count as annual leave at all.
          # Then retrieve all the public holidays that are half days, since they should count, but only
          # as half a day of annual leave.
          if (country = employee.current_employment_contract.try(:country)).present?
            ph_dates = ::Refinery::Employees::PublicHoliday.where('country = ? AND holiday_date >= ? AND holiday_date <= ? AND half_day = ?', country, start_date, end_date, false).map(&:holiday_date)
            half_day_ph_dates = ::Refinery::Employees::PublicHoliday.where('country = ? AND holiday_date >= ? AND holiday_date <= ? AND half_day = ?', country, start_date, end_date, true).map(&:holiday_date)
          else
            ph_dates = []
            half_day_ph_dates = []
          end

          # Set the number of days to the amount of dates in the leave that are neither a weekend nor
          # a public holiday.
          self.number_of_days = (start_date..end_date).to_a.reject { |d| d.saturday? || d.sunday? || ph_dates.include?(d) }.count.to_f

          # Then deduct half a day for each date that was a half day public holiday
          self.number_of_days -= 0.5 * half_day_ph_dates.count

          # Then deduct half a day if the leave was starting or ending as a half day annual leave (unless
          # the starting or ending days was a half dau public holiday in which case it has already been
          # accounted for).
          self.number_of_days -= 0.5 if start_half_day && !half_day_ph_dates.include?(start_date)
          self.number_of_days -= 0.5 if end_half_day && !half_day_ph_dates.include?(end_date)
        else
          # Check that start_date is not on a weekend or whole-day public holiday
          if start_date.saturday? || start_date.sunday?
            errors.add(:start_date, 'Cannot start annual leave on non-working day')
          end

          if (country = employee.current_employment_contract.try(:country)).present? &&
              (ph = ::Refinery::Employees::PublicHoliday.where('country = ? AND holiday_date = ?', country, start_date).first).present?
            if ph.half_day
              self.number_of_days = 0.5
            else
              errors.add(:start_date, 'Cannot start annual leave on public holiday')
            end
          else
            # We assume it is only one day leave
            self.number_of_days = (start_half_day ? 0.5 : 1 )
          end
        end

        errors.add(:number_of_days, 'must be higher than 0') unless number_of_days > 0

        errors.empty? # Rollback if any errors are present
      end

      # Create AnnualLeaveRecord records
      after_save do
        public_holidays =
            if (country = employee.current_employment_contract.try(:country)).present?
              ::Refinery::Employees::PublicHoliday.where('country = ? AND holiday_date >= ? AND holiday_date <= ?', country, start_date, end_date)
            else
              []
            end
        created_record_ids = []
        dates = (end_date.present? ? (start_date..end_date) : [start_date]).to_a
        dates.each_with_index do |date, i|
          if date.saturday? or date.sunday? or ((ph = public_holidays.detect { |ph| ph.holiday_date == date }).present? and !ph.half_day)
            # Do not create
          else
            record = annual_leave_records.detect { |alr| alr.record_date == date } || annual_leave_records.build(record_type: 'Vacation', record_date: date)
            if public_holidays.detect { |ph| ph.holiday_date == date }.try(:half_day)
              record.record_value = 0.5
            elsif i == 0 and start_half_day
              record.record_value = 0.5
            elsif end_date.present? && i == dates.length-1 && end_half_day
              record.record_value = 0.5
            else
              record.record_value = 1
            end
            record.save!
            created_record_ids << record.id
          end
        end

        annual_leave_records.where('id NOT IN (?)', created_record_ids << -1).each(&:destroy)
      end

      def employee_name
        @employee_name ||= employee.try(:full_name)
      end

    end
  end
end
