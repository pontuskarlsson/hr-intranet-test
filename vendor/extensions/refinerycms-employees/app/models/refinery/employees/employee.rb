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

      attr_writer :user_name, :xero_guid_field
      attr_accessible :user_id, :employee_no, :full_name, :id_no, :profile_image_id, :title, :position, :xero_guid, :xero_guid_field, :user_name

      validates :employee_no, presence: true, uniqueness: true
      validates :full_name,   presence: true
      validates :user_id,     uniqueness: true, allow_nil: true
      validates :xero_guid,   uniqueness: true, allow_blank: true

      before_validation do
        if @user_name.present?
          if (user = ::Refinery::User.find_by_username(@user_name)).present?
            self.user = user
          end
        end
        if @xero_guid_field.present?
          # To make it easier to select in the form, this field might contain
          # the name of the person the guid belongs to appended at the end of
          # the string.
          # Makes sure that only the guid and not any possible name gets saved
          self.xero_guid = @xero_guid_field.split(' ').first
        end
      end

      def user_name
        @user_name ||= user.try(:username)
      end

      def xero_guid_field
        @xero_guid_field ||= xero_guid
      end

      def current_employment_contract
        @_cec ||= employment_contracts.where(end_date: nil).first
      end

      def recent_sick_leave(search_weekdays = 3)
        return @_rsl if defined? @_rsl

        d = Date.today
        while search_weekdays > 0
          d -= 1.day
          search_weekdays -= 1 unless d.saturday? or d.sunday?
        end

        @_rsl = sick_leaves.where('(end_date IS NOT NULL AND end_date >= :date) OR start_date >= :date', date: d).order('start_date DESC').first
      end

      class << self
        # Scope to get all employees with active employment contracts
        def current
          joins(:employment_contracts).
              where("#{Refinery::Employees::EmploymentContract.table_name}.start_date <= :today "<<
                        "AND (#{Refinery::Employees::EmploymentContract.table_name}.end_date IS NULL OR #{Refinery::Employees::EmploymentContract.table_name}.end_date >= :today)", today: Date.today)
        end
      end

    end
  end
end
