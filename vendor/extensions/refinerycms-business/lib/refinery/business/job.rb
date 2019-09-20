require 'active_support/concern'
module Refinery
  module Business
    module Job
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods
        def configure_job(klass, assoc_name, options = {})
          ::Refinery::Business::Billable.register_job(klass, assoc_name, options)
          ::Refinery::Business::Section.register_job(klass, assoc_name, options)
        end
      end
    end
  end
end
