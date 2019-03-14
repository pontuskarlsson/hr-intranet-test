module Refinery
  module Business
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Business

      engine_name :refinery_business

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "business"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.business_admin_sales_orders_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Business)
      end
    end
  end
end
