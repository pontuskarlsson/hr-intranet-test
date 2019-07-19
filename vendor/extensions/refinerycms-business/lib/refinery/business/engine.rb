module Refinery
  module Business
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Business

      engine_name :refinery_business

      initializer 'resource-authorization-hooks-for-business-engine' do |app|
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Business::ROLE_INTERNAL
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Business::ROLE_EXTERNAL do |user, conditions|
          user.present? && conditions.has_key?(:contact_id) # Allow external users to see contact profile pictures
        end
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "business"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.business_admin_companies_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Business)
      end
    end
  end
end
