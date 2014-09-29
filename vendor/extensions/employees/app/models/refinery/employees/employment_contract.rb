module Refinery
  module Employees
    class EmploymentContract < Refinery::Core::BaseModel
      self.table_name = 'refinery_employment_contracts'

      belongs_to :employee

      attr_writer :employee_name
      attr_accessible :start_date, :end_date, :vacation_days_per_year, :employee_name

      validates :employee_id,   presence: true
      validates :start_date,    presence: true

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

    end
  end
end
