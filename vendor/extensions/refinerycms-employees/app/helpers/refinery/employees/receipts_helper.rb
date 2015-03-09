module Refinery
  module Employees
    module ReceiptsHelper

      def featured_xero_accounts
        @_featured_xero_accounts ||= ::Refinery::Employees::XeroAccount.featured.order('code ASC')
      end

      def all_xero_accounts
        @_all_xero_accounts ||= ::Refinery::Employees::XeroAccount.order('code ASC')
      end

    end
  end
end
