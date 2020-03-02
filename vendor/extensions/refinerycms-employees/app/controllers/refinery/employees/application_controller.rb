module Refinery
  module Employees
    class ApplicationController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      helper_method :has_content?

      protected

      def has_content?
        if current_refinery_user.has_role? ROLE_EXTERNAL
          billables_scope.exists?
        else
          true
        end
      end

      def server_side?
        params.has_key? :draw
      end

    end
  end
end
