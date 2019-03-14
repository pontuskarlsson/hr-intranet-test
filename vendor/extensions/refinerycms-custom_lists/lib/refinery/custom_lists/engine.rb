module Refinery
  module CustomLists
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::CustomLists

      engine_name :refinery_custom_lists

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "custom_lists"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.custom_lists_admin_custom_lists_path }
          plugin.pathname = root
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::CustomLists)
      end
    end
  end
end
