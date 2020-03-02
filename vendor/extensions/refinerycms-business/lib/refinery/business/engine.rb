module Refinery
  module Business
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery::Business
      engine_name :refinery_business

      initializer 'controller-scope-mixin-hooks-for-business-engine' do |app|
        ::ApplicationController.send(:include, ::Refinery::Business::ControllerScopeMixin)
      end

      initializer 'resource-authorization-hooks-for-business-engine' do |app|
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Business::ROLE_INTERNAL
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::Business::ROLE_EXTERNAL do |user, conditions|
          if user.present?
            if conditions.has_key?(:contact_id) # Allow external users to see contact profile pictures
              true

            elsif conditions.has_key?(:company_id)
              user.company_ids.include? conditions[:company_id].to_i

            else
              false
            end

          else
            false
          end
        end
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "business"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.business_admin_companies_path }
          plugin.pathname = root

          # Menu match controls access to the admin backend routes.
          plugin.menu_match = %r{refinery/business(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Business)
      end
    end
  end
end
