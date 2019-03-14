module Refinery
  module Employees
    include ActiveSupport::Configurable

    config_accessor :mailer_from_address

    self.mailer_from_address = 'no-reply@domain.com'
  end
end
