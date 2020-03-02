require 'active_support/concern'

module Refinery
  module Business
    module ControllerScopeMixin
      extend ActiveSupport::Concern

      included do
        before_action :find_selected_company

        helper_method :selected_company
      end

      # === selected_company_uuid
      #
      #
      def selected_company_uuid
        unless session[:selected_company_uuid]
          if current_refinery_user.respond_to?(:companies)
            session[:selected_company_uuid] = current_refinery_user.companies.limit(1).pluck(:uuid)[0]
          else
            session[:selected_company_uuid] = nil
          end
        end

        session[:selected_company_uuid]
      end


      # === find_selected_company
      #
      #
      def find_selected_company
        if selected_company_uuid.present?
          @selected_company = Refinery::Business::Company.for_user_roles(current_refinery_user).find_by!(uuid: selected_company_uuid)
        end
      rescue ActiveRecord::RecordNotFound
        session.delete(:selected_company_uuid)
        not_found
      end

      def selected_company
        @selected_company
      end

      def select_company!(company)
        session[:selected_company_uuid] = company.uuid
      end

      def unselect_company!
        session.delete(:selected_company_uuid)
      end

    end
  end
end
