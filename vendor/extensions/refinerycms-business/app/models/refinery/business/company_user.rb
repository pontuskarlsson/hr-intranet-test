module Refinery
  module Business
    class CompanyUser < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_company_users'

      ROLES = %w(Owner Manager)

      belongs_to :company
      belongs_to :user, class_name: 'Refinery::Authentication::Devise::User'

      validates :company_id,    presence: true
      validates :user_id,       presence: true, uniqueness: { scope: :company_id }
      validates :role,          inclusion: ROLES, allow_nil: true

    end
  end
end
