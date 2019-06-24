module Refinery
  module Shipping
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Shipping

      engine_name :refinery_shipping

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "shipping"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.shipping_admin_parcels_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Shipping)
      end
    end
  end
end
