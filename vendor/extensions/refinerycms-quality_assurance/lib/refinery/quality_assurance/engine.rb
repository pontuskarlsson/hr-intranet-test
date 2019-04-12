module Refinery
  module QualityAssurance
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::QualityAssurance

      engine_name :refinery_quality_assurance

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "quality_assurance"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.quality_assurance_admin_inspections_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::QualityAssurance)
      end
    end
  end
end
