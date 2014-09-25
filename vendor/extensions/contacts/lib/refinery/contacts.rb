require 'refinerycms-core'

module Refinery
  autoload :ContactsGenerator, 'generators/refinery/contacts_generator'

  module Contacts
    require 'refinery/contacts/engine'
    require 'refinery/contacts/base_synchroniser'

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
