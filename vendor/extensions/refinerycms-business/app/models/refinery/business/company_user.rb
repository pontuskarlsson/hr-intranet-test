module Refinery
  module Business
    class CompanyUser < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_company_users'

      ROLES = %w(Owner Manager)

      attr_accessor :new_user_email

      belongs_to :company, optional: true
      belongs_to :user, class_name: 'Refinery::Authentication::Devise::User', optional: true

      validates :company_id,    presence: true
      validates :user_id,       presence: true, uniqueness: { scope: :company_id }
      validates :role,          inclusion: ROLES, allow_nil: true

      before_validation(on: :create) do
        if new_user_email.present?
          self.user = Refinery::Authentication::Devise::User.find_by(email: new_user_email)
        end
      end

      scope :owner, -> { where(role: 'Owner') }

    end
  end
end
