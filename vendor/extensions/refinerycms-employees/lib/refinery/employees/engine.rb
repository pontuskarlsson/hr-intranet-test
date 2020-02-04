module Refinery
  module Employees
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Employees

      engine_name :refinery_employees

      initializer 'resource-authorization-hooks-for-employees-engine' do |app|
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Employees::ROLE_EMPLOYEE
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "employees"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.employees_admin_employees_path }
          plugin.pathname = root
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'leave', 'leaves'
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Employees)

        #Xeroizer::Logging::Log = Rails.logger
        #Xeroizer::Record::BaseModel::DEFAULT_RECORDS_PER_BATCH_SAVE = 50
      end
    end
  end
end
