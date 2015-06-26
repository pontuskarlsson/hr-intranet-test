require 'refinerycms-core'

module Refinery
  autoload :PageRolesGenerator, 'generators/refinery/page_roles_generator'

  module PageRoles
    require 'refinery/page_roles/engine'
    require 'refinery/page_roles/configuration'

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
