require 'refinerycms-core'
require 'countries'

module Refinery
  autoload :BusinessGenerator, 'generators/refinery/business_generator'

  module Business
    require 'refinery/business/configuration'
    require 'refinery/business/engine'
    require 'refinery/business/job'
    require 'refinery/business/xero/sync/contacts'
    require 'refinery/business/xero/sync/invoices'
    require 'refinery/business/xero/sync/items'
    require 'refinery/business/xero/client'
    require 'refinery/business/xero/syncer'

    autoload :Version, 'refinery/business/version'

    ROLE_EXTERNAL = 'Business:External'
    ROLE_INTERNAL = 'Business:Internal'
    ROLE_INTERNAL_FINANCE = 'Business:Internal:Finance'

    PAGE_BILLABLES_URL    = '/business/billables'
    PAGE_BILLS_URL        = '/business/bills'
    PAGE_BUDGETS_URL      = '/business/budgets'
    PAGE_COMPANIES_URL    = '/business/companies'
    PAGE_INVOICES_URL     = '/business/invoices'
    PAGE_ORDERS_URL       = '/business/orders'
    PAGE_PROJECTS_URL     = '/business/projects'
    PAGE_REQUESTS_URL     = '/business/requests'
    PAGE_SECTIONS_URL     = '/business/sections'

    QUARTERS = {
        'Q1' => 1..3,
        'Q2' => 4..6,
        'Q3' => 7..9,
        'Q4' => 10..12
    }

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def version
        ::Refinery::Business::Version.to_s
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
