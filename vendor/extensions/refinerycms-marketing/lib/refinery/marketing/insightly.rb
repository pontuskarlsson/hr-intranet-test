module Refinery
  module Marketing
    module Insightly
      class << self
        attr_accessor :configuration
      end

      def self.configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end

      class Configuration
        attr_accessor :updates_allowed

        def initialize
          @updates_allowed = false
        end
      end
    end
  end
end
