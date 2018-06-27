module Refinery
  module Employees
    class PublicHoliday < Refinery::Core::BaseModel
      self.table_name = 'refinery_public_holidays'

      CALENDAR_FUNCTION_PREFIX = 'PublicHolidays_'

      belongs_to :event,          class_name: '::Refinery::Calendar::Event', dependent: :destroy

      attr_accessible :holiday_date, :half_day, :country, :title

      validates :title,         presence: true
      validates :event_id,      uniqueness: true, allow_nil: true
      validates :holiday_date,  presence: true, uniqueness: { scope: :country }
      validates :country,       presence: true, inclusion: ::Refinery::Employees::Countries::COUNTRIES

      before_save do
        unless event.present?
          # This creates a Calendar for the specific function of displaying Sick Leave events.
          calendar = ::Refinery::Calendar::Calendar.find_or_create_by_function!(CALENDAR_FUNCTION_PREFIX+country, { title: "Public Holidays (#{country})", private: false, activate_on_create: true })
          self.event = calendar.events.build
        end

        event.title = title
        event.excerpt = half_day ? ' Half Day' : ''
        event.starts_at = half_day ? holiday_date.beginning_of_day + 14.hours : holiday_date.beginning_of_day
        event.ends_at = holiday_date.end_of_day

        event.save!
        self.event_id = event.id
      end

      def self.all_calendar_functions
        ::Refinery::Employees::Countries::COUNTRIES.map { |country| "#{CALENDAR_FUNCTION_PREFIX}#{country}" }
      end

    end
  end
end
