module Refinery
  module Addons
    class Engine < Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery::Addons
      engine_name :refinery_addons

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.hide_from_menu = true
          plugin.name = "addons"
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Addons)
      end
    end
  end
end
