module Refinery
  module QualityAssurance
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::QualityAssurance

      engine_name :refinery_quality_assurance

      initializer 'resource-authorization-hooks-for-business-engine' do |app|
        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::QualityAssurance::ROLE_INTERNAL

        ::Refinery::ResourceAuthorizations::AccessControl.allow! Refinery::QualityAssurance::ROLE_EXTERNAL do |user, conditions|
          inspection = Inspection.find conditions[:inspection_id]
          user.company_ids.include? inspection.company_id
        end
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "quality_assurance"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.quality_assurance_admin_inspections_path }
          plugin.pathname = root

          # Menu match controls access to the admin backend routes.
          plugin.menu_match = %r{refinery/quality_assurance(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::QualityAssurance)
      end
    end
  end
end
