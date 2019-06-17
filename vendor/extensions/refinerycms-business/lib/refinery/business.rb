require 'refinerycms-core'

module Refinery
  autoload :BusinessGenerator, 'generators/refinery/business_generator'

  module Business
    require 'refinery/business/engine'
    require 'refinery/business/xero/client'
    require 'refinery/business/xero/syncer'

    ROLE_EXTERNAL = 'Business:External'
    ROLE_INTERNAL = 'Business:Internal'
    ROLE_INTERNAL_FINANCE = 'Business:Internal:Finance'

    PAGE_BUDGETS_URL      = '/business/budgets'
    PAGE_COMPANIES_URL    = '/business/companies'
    PAGE_INVOICES_URL     = '/business/invoices'
    PAGE_PROJECTS_URL     = '/business/projects'
    PAGE_SALES_ORDERS_URL = '/business/sales_orders'
    PAGE_SECTIONS_URL     = '/business/sections'

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
