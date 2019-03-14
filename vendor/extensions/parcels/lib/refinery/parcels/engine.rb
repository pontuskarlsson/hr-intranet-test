module Refinery
  module Parcels
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Parcels

      engine_name :refinery_parcels

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "parcels"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.parcels_admin_parcels_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Parcels)
      end
    end
  end
end
