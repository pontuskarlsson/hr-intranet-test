require 'refinerycms-core'

module Refinery
  autoload :MarketingGenerator, 'generators/refinery/marketing_generator'

  module Marketing
    require 'refinery/marketing/configuration'
    require 'refinery/marketing/engine'
    require 'refinery/marketing/base_synchroniser'
    require 'refinery/marketing/insightly'
    require 'refinery/marketing/insightly/client'
    require 'refinery/marketing/insightly/resource'
    require 'refinery/marketing/insightly/resource_list'
    require 'refinery/marketing/insightly/synchroniser'

    ROLE_CRM_MANAGER = 'Marketing:CRM:Manager'

    PAGE_BRANDS_URL = '/marketing/brands'
    PAGE_CONTACTS_URL = '/marketing/contacts'

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
