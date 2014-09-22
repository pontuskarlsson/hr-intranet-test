module Refinery
  module SalesOrders
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::SalesOrders

      engine_name :refinery_sales_orders

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "sales_orders"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.sales_orders_admin_sales_orders_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/sales_orders/sales_order',
            :title => 'order_id'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::SalesOrders)
      end
    end
  end
end
