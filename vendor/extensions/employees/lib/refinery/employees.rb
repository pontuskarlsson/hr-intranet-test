require 'refinerycms-core'

module Refinery
  autoload :EmployeesGenerator, 'generators/refinery/employees_generator'

  module Employees
    require 'refinery/employees/engine'
    require 'refinery/employees/user_employee_addon'
    require 'refinery/employees/countries'
    require 'refinery/employees/xero_client'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
