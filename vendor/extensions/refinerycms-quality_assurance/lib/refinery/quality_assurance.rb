require 'refinerycms-core'

module Refinery
  autoload :QualityAssuranceGenerator, 'generators/refinery/quality_assurance_generator'

  module QualityAssurance
    require 'refinery/quality_assurance/engine'

    ROLE_INTERNAL = 'QualityAssurance:Internal'
    ROLE_INTERNAL_MANAGER = 'QualityAssurance:Internal:Manager'
    ROLE_EXTERNAL = 'QualityAssurance:External'
    ROLE_INSPECTOR = 'QualityAssurance:Inspector'

    PAGE_INSPECTIONS_URL = '/quality_assurance/inspections'
    PAGE_JOBS_URL = '/quality_assurance/jobs'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
