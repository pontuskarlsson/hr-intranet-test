require 'refinerycms-core'

module Refinery
  autoload :MarketingGenerator, 'generators/refinery/marketing_generator'

  module Marketing
    require 'refinery/marketing/engine'
    require 'refinery/marketing/amqp_messenger'
    require 'refinery/marketing/base_synchroniser'

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
