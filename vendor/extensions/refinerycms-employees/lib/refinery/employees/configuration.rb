module Refinery
  module Employees
    include ActiveSupport::Configurable

    config_accessor :user_attribute_reference

    self.user_attribute_reference = :username
  end
end
