module Refinery
  module Employees
    module ReceiptsHelper

      def featured_xero_accounts
        @_featured_xero_accounts ||= ::Refinery::Employees::XeroAccount.where(show_in_expense_claims: true).featured.order('code ASC')
      end

      def all_xero_accounts
        @_all_xero_accounts ||= ::Refinery::Employees::XeroAccount.where(show_in_expense_claims: true).order('code ASC')
      end

    end
  end
end
