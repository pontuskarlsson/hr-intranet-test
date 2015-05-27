require 'refinerycms-core'

module Refinery
  autoload :ParcelsGenerator, 'generators/refinery/parcels_generator'

  module Parcels
    require 'refinery/parcels/engine'
    require 'refinery/parcels/configuration'
    require 'refinery/parcels/easy_post'

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
