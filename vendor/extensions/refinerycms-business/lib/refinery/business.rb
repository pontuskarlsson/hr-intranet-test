require 'refinerycms-core'

module Refinery
  autoload :BusinessGenerator, 'generators/refinery/business_generator'

  module Business
    require 'refinery/business/engine'
    require 'refinery/business/cin7_importer'

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
