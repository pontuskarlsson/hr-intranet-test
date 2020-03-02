require 'refinerycms-core'

module Refinery
  autoload :EmployeesGenerator, 'generators/refinery/employees_generator'

  module Employees
    require 'refinery/employees/engine'
    require 'refinery/employees/configuration'
    require 'refinery/employees/countries'
    require 'refinery/employees/xero_client'
    require 'refinery/employees/xero_submit_job'

    ROLE_EMPLOYEE = 'Employees:Employee'

    PAGE_ALL_LOA            = '/employees/all_leave_of_absences'
    PAGE_ANNUAL_LEAVES      = '/employees/annual_leaves'
    PAGE_CHART_OF_ACCOUNTS  = '/employees/chart_of_accounts'
    PAGE_EMPLOYEES          = '/employees/employees'
    PAGE_EXPENSE_CLAIMS     = '/employees/expense_claims'
    PAGE_SICK_LEAVES        = '/employees/sick_leaves'

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
