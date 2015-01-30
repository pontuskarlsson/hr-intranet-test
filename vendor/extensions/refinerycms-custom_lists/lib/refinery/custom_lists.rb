require 'refinerycms-core'

module Refinery
  autoload :CustomListsGenerator, 'generators/refinery/custom_lists_generator'

  module CustomLists
    require 'refinery/custom_lists/engine'

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
