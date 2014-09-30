module Refinery
  module Employees
    class Employee < Refinery::Core::BaseModel
      self.table_name = 'refinery_employees'

      belongs_to :profile_image,      class_name: '::Refinery::Image'
      belongs_to :user,               class_name: '::Refinery::User'
      has_many :sick_leaves,          dependent: :destroy
      has_many :annual_leaves,        dependent: :destroy
      has_many :annual_leave_records, dependent: :destroy
      has_many :employment_contracts, dependent: :destroy

      attr_accessible :user_id, :employee_no, :full_name, :id_no, :profile_image_id, :title, :position

      validates :employee_no, presence: true, uniqueness: true
      validates :full_name,   presence: true
      validates :user_id,     uniqueness: true, allow_nil: true

      def current_employment_contract
        @_cec ||= employment_contracts.where(end_date: nil).first
      end

    end
  end
end
