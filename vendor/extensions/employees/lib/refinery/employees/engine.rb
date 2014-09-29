module Refinery
  module Employees
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Employees

      engine_name :refinery_employees

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "employees"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.employees_admin_employees_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/employees/employee',
            :title => 'employee_no'
          }
          
        end

        Refinery.include_once(::Refinery::User, Refinery::Employees::UserEmployeeAddon)
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Employees)
      end
    end
  end
end
