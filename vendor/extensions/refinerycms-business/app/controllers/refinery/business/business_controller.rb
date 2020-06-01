module Refinery
  module Business
    class BusinessController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      #set_page PAGE_DASHBOARD_URL

      helper_method :has_content?

      # def dashboard
      #
      # end

      protected

      def billables_scope
        @billables ||= Billable.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def bills_scope
        @bills ||= Invoice.bills.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def invoices_scope
        @invoices ||= Invoice.invoices.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def orders_scope
        @orders ||= Order.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def plans_scope
        @plans ||= Plan.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def projects_scope
        @projects ||= Project.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def purchases_scope
        @purchases = Purchase.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

      def requests_scope
        @requests = Request.for_selected_company(selected_company).for_user_roles(current_refinery_user)
      end

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

      def create_resource_from_content(file_content, file_name, access_hash = {})
        resource = Refinery::Resource.new.tap do |r|
          r.file = file_content
          r.file.name = file_name
          r.file_mime_type = r.file.mime_type
          r.authorizations_access = Refinery::Resource.access_string_for access_hash
        end

        resource.save!
        resource
      end

    end
  end
end
