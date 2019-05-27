module Refinery
  module ResourceAuthorizations
    class Engine < Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery::ResourceAuthorizations
      engine_name :refinery_resource_authorizations

      initializer 'configure-resource-authorization-with-dragonfly', after: 'attach-refinery-resources-with-dragonfly' do |app|
        ::Refinery::ResourceAuthorizations::Dragonfly.configure!
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.hide_from_menu = true
          plugin.name = "resource_authorizations"
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::ResourceAuthorizations)
      end
    end
  end
end
