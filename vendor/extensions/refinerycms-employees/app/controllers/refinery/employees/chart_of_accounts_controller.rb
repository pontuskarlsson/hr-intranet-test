module Refinery
  module Employees
    class ChartOfAccountsController < ::ApplicationController
      before_action :find_page

      def index
        @xero_accounts = XeroAccount.all
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      protected

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/employees/chart_of_accounts', current_refinery_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
