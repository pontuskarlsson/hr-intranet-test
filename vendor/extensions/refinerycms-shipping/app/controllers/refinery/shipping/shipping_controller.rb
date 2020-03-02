module Refinery
  module Shipping
    class ShippingController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      #set_page PAGE_DASHBOARD_URL

      helper_method :has_content?

      # def dashboard
      #
      # end

      protected

      def shipments_scope
        @shipments ||= Shipment.for_selected_company(selected_company).for_user_roles(current_refinery_user, @auth_role_titles)
      end

      def has_content?
        if current_refinery_user.has_role? ROLE_EXTERNAL
          shipments_scope.exists?
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
