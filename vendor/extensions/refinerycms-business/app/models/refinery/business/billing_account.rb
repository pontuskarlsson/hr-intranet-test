module Refinery
  module Business
    class BillingAccount < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_billing_accounts'

      EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

      belongs_to :company

      validates :name,  presence: true

      validate do
        if email_addresses.present?
          if email_addresses.split(',').any? { |email| !EMAIL_REGEX.match email.strip }
            errors.add(:email_addresses, 'one or more of the email adresses are incorrect')
          end
        end
      end

      scope :primary, -> { where(primary: true) }

    end
  end
end
