module Refinery
  module Employees
    class LeaveOfAbsence < Refinery::Core::BaseModel
      self.table_name = 'refinery_leave_of_absences'

      CALENDAR_FUNCTION = 'LeaveOfAbsence'

      TYPE_SICK_LEAVE = 1
      TYPE_ANNUAL_LEAVE = 2
      TYPE_COMPENSATION_LEAVE = 3
      TYPE_MATERNITY_LEAVE = 4
      TYPE_OTHER = 10

      TYPES_OF_LEAVE = {
          TYPE_SICK_LEAVE           => { label: 'Sick Leave',           abbreviation: 'SL',  apply: false },
          TYPE_ANNUAL_LEAVE         => { label: 'Annual Leave',         abbreviation: 'AL',  apply: true },
          TYPE_COMPENSATION_LEAVE   => { label: 'Compensation Leave',   abbreviation: 'CL',  apply: true },
          TYPE_MATERNITY_LEAVE      => { label: 'Maternity Leave',      abbreviation: 'ML',  apply: true },
          TYPE_OTHER                => { label: 'Other',                abbreviation: 'O',   apply: true }
      }.freeze

      STATUS_WAITING_FOR_APPROVAL = 1
      STATUS_APPROVED = 2
      STATUS_REJECTED = 3

      STATUSES = {
          STATUS_WAITING_FOR_APPROVAL => { label: 'Waiting for approval' },
          STATUS_APPROVED             => { label: 'Approved' },
          STATUS_REJECTED             => { label: 'Rejected' }
      }.freeze

      belongs_to :employee
      belongs_to :event,          class_name: '::Refinery::Calendar::Event', dependent: :destroy
      belongs_to :doctors_note,   class_name: '::Refinery::Resource'

      attr_writer :employee_name, :i_am_sick_today
      attr_accessible :start_date, :start_half_day, :end_date, :end_half_day, :doctors_note_id, :employee_name,
                      :absence_type_id, :absence_type_description, :status, :i_am_sick_today

      validates :employee_id,               presence: true
      validates :event_id,                  uniqueness: true, allow_nil: true
      validates :start_date,                presence: true
      validates :absence_type_id,           inclusion: TYPES_OF_LEAVE.keys
      validates :absence_type_description,  presence: true, if: proc { |r| r.absence_type_id == TYPE_OTHER }
      validates :status,                    inclusion: STATUSES.keys, if: proc { |r| r.absence_type[:apply] }
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
        if @i_am_sick_today == '1'
          self.start_date = Date.today
        end
      end

      before_save do
        if add_to_calendar?
          unless event.present?
            # This creates a Calendar for the specific function of displaying Leave of Absence events.
            calendar = ::Refinery::Calendar::Calendar.find_or_create_by_function!(CALENDAR_FUNCTION, { title: 'Leave of Absence', private: false, activate_on_create: true })
            self.event = calendar.events.build
          end

          event.title = "#{ absence_type[:abbreviation] }: #{ employee.full_name }"
          event.excerpt = absence_type[:label]
          event.starts_at = start_date.beginning_of_day  + (start_half_day ? 14.hours : 0)
          event.ends_at =  (end_half_day   ? end_date.beginning_of_day + 14.hours : end_date.end_of_day) if end_date.present?

          event.save!
          self.event_id = event.id # Not getting associated without this line...

        else
          # If add_to_calendar? is false but an Event already exists, destroy it.
          if event.present?
            errors.add(:event_id, 'could not be removed') unless event.destroy
          end
        end

        errors.empty? # Rollback if any errors are present
      end

      scope :sick_leaves,     where(absence_type_id: TYPE_SICK_LEAVE)
      scope :non_sick_leaves, where("#{table_name}.absence_type_id <> ?", TYPE_SICK_LEAVE)
      scope :approvable,      where(absence_type_id: TYPES_OF_LEAVE.map { |k,v| k if v[:apply] }.compact)

      def self.approvable_by(manager)
        if manager.user.present? && manager.user.plugins.where(name: 'refinerycms-employees').exists?
          approvable
        else
          approvable.where(employee_id: manager.employee_ids + [-1])
        end
      end

      def employee_name
        @employee_name ||= employee.try(:full_name)
      end

      def matches_date?(date)
        date == start_date ||
            (end_date.present? && date > start_date && date <= end_date)
      end

      def absence_type
        TYPES_OF_LEAVE[absence_type_id] || {}
      end

      def display_type_of_absence
        if absence_type_id == TYPE_OTHER
          absence_type_description
        else
          absence_type[:label]
        end
      end

      def display_status
        (STATUSES[status] || {})[:label]
      end

      def no_of_days

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
          number_of_days = (start_date..end_date).to_a.reject { |d| d.saturday? || d.sunday? || ph_dates.include?(d) }.count.to_f

          # Then deduct half a day for each date that was a half day public holiday
          number_of_days -= 0.5 * half_day_ph_dates.count

          # Then deduct half a day if the leave was starting or ending as a half day annual leave (unless
          # the starting or ending days was a half dau public holiday in which case it has already been
          # accounted for).
          number_of_days -= 0.5 if start_half_day && !half_day_ph_dates.include?(start_date)
          number_of_days -= 0.5 if end_half_day && !half_day_ph_dates.include?(end_date)
          number_of_days
        else
          # Check that start_date is not on a weekend or whole-day public holiday
          if start_date.saturday? || start_date.sunday?
            errors.add(:start_date, 'Cannot start annual leave on non-working day')
          end

          if (country = employee.current_employment_contract.try(:country)).present? &&
              (ph = ::Refinery::Employees::PublicHoliday.where('country = ? AND holiday_date = ?', country, start_date).first).present?
            if ph.half_day
              0.5
            else
              0
            end
          else
            # We assume it is only one day leave
            (start_half_day ? 0.5 : 1 )
          end
        end
      end

      def display_employee
        employee.full_name
      end

      private

      # Returns true if the LOA should be added to a calendar.
      def add_to_calendar?
        !absence_type[:apply] || status == STATUS_APPROVED
      end

    end
  end
end
