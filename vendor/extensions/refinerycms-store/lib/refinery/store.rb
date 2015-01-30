require 'refinerycms-core'

module Refinery
  autoload :OrdersGenerator, 'generators/refinery/store_generator'

  module Store
    require 'refinery/store/engine'
    require 'refinery/store/user_addon'

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
