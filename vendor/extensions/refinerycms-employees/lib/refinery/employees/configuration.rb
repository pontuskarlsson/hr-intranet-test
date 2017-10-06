module Refinery
  module Employees
    include ActiveSupport::Configurable

    config_accessor :user_attribute_reference, :mailer_from_address

    self.user_attribute_reference = :username

    self.mailer_from_address = 'no-reply@domain.com'
  end
end
