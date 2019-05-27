require 'refinerycms-core'

module Refinery
  autoload :ResourceAuthorizationsGenerator, 'generators/refinery/resource_authorizations_generator'

  module ResourceAuthorizations
    require 'refinery/resource_authorizations/access_control'
    require 'refinery/resource_authorizations/configuration'
    require 'refinery/resource_authorizations/dragonfly'
    require 'refinery/resource_authorizations/engine'

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
