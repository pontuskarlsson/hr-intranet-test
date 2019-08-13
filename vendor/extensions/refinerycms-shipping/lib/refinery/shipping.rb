require 'refinerycms-core'

module Refinery
  autoload :ShippingGenerator, 'generators/refinery/shipping_generator'

  module Shipping
    require 'refinery/shipping/engine'
    require 'refinery/shipping/configuration'
    require 'refinery/shipping/easy_post'

    PAGE_PARCELS_URL = '/shipping/parcels'
    PAGE_SHIPMENTS_URL = '/shipping/shipments'

    ROLE_INTERNAL = 'Shipping:Internal'
    ROLE_EXTERNAL = 'Shipping:External'
    ROLE_EXTERNAL_FF = 'Shipping:External:FreightForwarder'

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
