require 'active_support/concern'

module Refinery
  module ResourceAuthorizations
    module Grants
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods

        def grant_all(*args)

        end

        def grant_conditional(*args)
          
        end

      end
    end
  end
end
