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
      has_many :xero_expense_claims,  dependent: :destroy
      has_many :xero_receipts,        dependent: :destroy

      attr_writer :user_name
      attr_accessible :user_id, :employee_no, :full_name, :id_no, :profile_image_id, :title, :position, :xero_guid, :user_name

      validates :employee_no, presence: true, uniqueness: true
      validates :full_name,   presence: true
      validates :user_id,     uniqueness: true, allow_nil: true
      validates :xero_guid,   uniqueness: true, allow_blank: true

      before_validation do
        if @user_name.present?
          if (user = ::Refinery::User.find_by_full_name(@user_name)).present?
            self.user = user
          end
        end
      end

      def user_name
        @user_name ||= user.try(:full_name)
      end

      def current_employment_contract
        @_cec ||= employment_contracts.where(end_date: nil).first
      end

    end
  end
end
