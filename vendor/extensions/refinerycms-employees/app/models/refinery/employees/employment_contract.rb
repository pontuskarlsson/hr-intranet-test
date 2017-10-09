module Refinery
  module Employees
    class EmploymentContract < Refinery::Core::BaseModel
      self.table_name = 'refinery_employment_contracts'

      belongs_to :employee

      attr_writer :employee_name
      attr_accessible :start_date, :end_date, :vacation_days_per_year, :employee_name, :country, :days_carried_over

      validates :employee_id,   presence: true
      validates :start_date,    presence: true
      validates :end_date,      uniqueness: { scope: :employee_id }, if: proc { |ec| ec.end_date.nil? } # Makes sure that only one unterminated contract is allowed at a time
      validates :country,       inclusion: ::Refinery::Employees::Countries::COUNTRIES

      before_validation do
        if @employee_name.present?
          if (employee = Employee.find_by_full_name(@employee_name)).present?
            self.employee = employee
          end
        end
      end

      def employee_name
        @employee_name ||= employee.try(:full_name)
      end

      def applicable_public_holidays
        if end_date.present?
          ::Refinery::Employees::PublicHoliday.where(country: country).where('holiday_date >= ?', start_date).where('holiday_date <=', end_date)
        else
          ::Refinery::Employees::PublicHoliday.where(country: country).where('holiday_date >= ?', start_date)
        end
      end

      class << self
        def current_contracts
          where("#{table_name}.start_date <= :today AND (#{table_name}.end_date IS NULL OR #{table_name}.end_date >= :today)", today: Date.today)
        end
      end

    end
  end
end
