module Refinery
  module Marketing
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Marketing

      engine_name :refinery_marketing

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "marketing"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.marketing_admin_brands_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/marketing/brand',
            :title => 'name'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Marketing)
      end
    end
  end
end
