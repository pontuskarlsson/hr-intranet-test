require 'active_support/concern'
require 'refinerycms-authentication'

module Refinery
  module Employees
    module UserEmployeeAddon
      extend ActiveSupport::Concern

      included do
        has_one :employee,    class_name: '::Refinery::Employees::Employee'
      end

    end
  end
end
