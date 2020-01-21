module Refinery
  module Marketing
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Marketing

      engine_name :refinery_marketing

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "marketing"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.marketing_admin_contacts_path }
          plugin.pathname = root

          # Menu match controls access to the admin backend routes.
          plugin.menu_match = %r{refinery/marketing(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Marketing)
      end
    end
  end
end
