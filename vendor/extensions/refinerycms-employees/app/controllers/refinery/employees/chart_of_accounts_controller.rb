module Refinery
  module Employees
    class ChartOfAccountsController < ::ApplicationController
      before_filter :find_page

      def index
        @xero_accounts = XeroAccount.all
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      protected

      def find_page
        @page = ::Refinery::Page.where(:link_url => '/employees/chart_of_accounts').first
      end

    end
  end
end
