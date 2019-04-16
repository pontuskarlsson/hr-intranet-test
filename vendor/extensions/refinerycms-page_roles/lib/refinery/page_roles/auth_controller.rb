require 'active_support/concern'

module Refinery
  module PageRoles
    module AuthController
      extend ActiveSupport::Concern

      included do
        class_attribute :allowed_page_roles
        self.allowed_page_roles = {}

        before_filter :find_and_auth_page

        helper_method :page_role?
      end

      def find_and_auth_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/business/companies', current_authentication_devise_user)
        @auth_role_titles = @page.user_page_role_titles & action_roles
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def page_role?(title)
        @auth_role_titles.include? title
      end

      def action_roles(action = params[:action])
        allowed_page_roles.each_pair.inject([]) { |acc, (a, roles)|
          a == '*' || action == a.to_s ? acc + roles : acc
        }.uniq
      end


      module ClassMethods

        def allow_page_roles(role, options = {})
          actions = options[:only] || ['*']
          actions.each do |a|
            self.allowed_page_roles[a] ||= []
            self.allowed_page_roles[a] << role
          end
        end

      end

    end
  end
end
