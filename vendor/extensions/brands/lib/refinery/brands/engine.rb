module Refinery
  module Brands
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Brands

      engine_name :refinery_brands

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "brands"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.brands_admin_brands_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/brands/brand',
            :title => 'name'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Brands)
      end
    end
  end
end
