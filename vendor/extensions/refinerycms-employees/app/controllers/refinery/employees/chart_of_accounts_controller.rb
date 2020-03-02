module Refinery
  module Employees
    class ChartOfAccountsController < ::Refinery::Employees::ApplicationController
      set_page PAGE_CHART_OF_ACCOUNTS

      def index
        @xero_accounts = XeroAccount.all
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

    end
  end
end
