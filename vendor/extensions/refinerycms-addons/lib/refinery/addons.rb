require 'refinerycms-core'

module Refinery
  autoload :AddonsGenerator, 'generators/refinery/addons_generator'

  module Addons
    require 'refinery/addons/configure_enumerables'
    require 'refinery/addons/configure_label'
    require 'refinery/addons/data_tables'
    require 'refinery/addons/display_decorators'
    require 'refinery/addons/engine'

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
