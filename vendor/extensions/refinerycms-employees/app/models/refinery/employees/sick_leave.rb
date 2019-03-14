module Refinery
  module Employees
    class SickLeave < Refinery::Core::BaseModel
      self.table_name = 'refinery_sick_leaves'

      CALENDAR_FUNCTION = 'SickLeave'

      belongs_to :employee
      belongs_to :event,          class_name: '::Refinery::Calendar::Event', dependent: :destroy
      belongs_to :doctors_note,   class_name: '::Refinery::Resource'

      attr_writer :employee_name
      #attr_accessible :start_date, :start_half_day, :end_date, :end_half_day, :doctors_note_id, :employee_name

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
          calendar = ::Refinery::Calendar::Calendar.find_or_create_by_function!(CALENDAR_FUNCTION, { title: 'Sick Leave', private: false, activate_on_create: true })
          self.event = calendar.events.build
        end

        event.title = "SL: #{ employee.full_name }"
        event.excerpt = 'Sick Leave'
        event.starts_at = start_date.beginning_of_day  + (start_half_day ? 14.hours : 0)
        event.ends_at =  (end_half_day   ? end_date.beginning_of_day + 14.hours : end_date.end_of_day) if end_date.present?

        event.save!
        self.event_id = event.id # Not getting associated without this line...

        # Start by retrieving all public holidays that are in between the starting and ending dates of
        # the sick leave and is not a half day (sick leave on half days still counts as whole day of sick leave).
        if (country = employee.current_employment_contract.try(:country)).present?
          ph_dates = ::Refinery::Employees::PublicHoliday.where('country = ? AND holiday_date >= ? AND holiday_date <= ? AND half_day = ?', country, start_date, end_date, false).map(&:holiday_date)
        else
          ph_dates = []
        end

        if end_date.present?
          # We can calculate the entire leave

          # Remove all days in the sick leave range that are either a weekend or a public holiday
          self.number_of_days = (start_date..end_date).to_a.reject { |d| d.saturday? || d.sunday? || ph_dates.include?(d) }.count.to_f

          # If the sick leave started with half day (i.e. employee left after lunch, NOT employee was
          # sick on a half day public holiday), then we reduce the sick leave with half a day, same
          # if the leave ended with half day.
          self.number_of_days -= 0.5 if start_half_day
          self.number_of_days -= 0.5 if end_half_day
        else
          # Check that start_date is not on a weekend or whole-day public holiday
          if start_date.saturday? || start_date.sunday? || ph_dates.include?(start_date)
            errors.add(:start_date, 'Cannot start sick leave on non-working day')
          end

          # We assume it is only one day leave
          self.number_of_days = (start_half_day ? 0.5 : 1 )
        end

        errors.add(:number_of_days, 'must be higher than 0') unless number_of_days > 0

        errors.empty? # Rollback if any errors are present
      end

      def employee_name
        @employee_name ||= employee.try(:full_name)
      end

      def matches_date?(date)
        date == start_date ||
            (end_date.present? && date > start_date && date <= end_date)
      end

    end
  end
end
