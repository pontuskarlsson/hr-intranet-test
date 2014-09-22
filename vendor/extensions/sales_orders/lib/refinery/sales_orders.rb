require 'refinerycms-core'

module Refinery
  autoload :SalesOrdersGenerator, 'generators/refinery/sales_orders_generator'

  module SalesOrders
    require 'refinery/sales_orders/engine'
    require 'refinery/sales_orders/cin7_importer'

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
