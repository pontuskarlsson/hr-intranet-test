module Refinery
  module Employees
    class AnnualLeaveRecord < Refinery::Core::BaseModel
      self.table_name = 'refinery_annual_leave_records'

      RECORD_TYPES = %w(Vacation Expired Adjustment)

      belongs_to :employee
      belongs_to :annual_leave

      #attr_accessible :record_date, :record_type, :record_value

      validates :employee_id,       presence: true
      validates :annual_leave_id,   presence: true
      validates :record_date,       presence: true
      validates :record_type,       inclusion: RECORD_TYPES

      before_validation do
        if annual_leave.present?
          self.employee_id = annual_leave.employee_id
        end
      end


    end
  end
end
