module Refinery
  module Employees
    module Admin
      class XeroAccountsController < ::Refinery::AdminController

        # The only actions we use here is index, edit and update
        crudify :'refinery/employees/xero_account',
                :title_attribute => 'code',
                order: 'featured DESC, code ASC'

        def sync_accounts
          if sync_accounts_from_xero
            flash[:notice] = 'Xero Accounts successfully synchronised'
          else
            flash[:alert] = 'Something went wrong while synchronising Xero Accounts'
          end
          redirect_to refinery.employees_admin_xero_accounts_path
        end

        private

        def sync_accounts_from_xero
          ::Refinery::Employees::XeroClient.new(::Refinery::Business::Account::HRL).sync_accounts
        rescue StandardError => e
          false
        end

        def xero_account_params
          params.require(:xero_account).permit(
              :featured, :when_to_use
          )
        end

      end
    end
  end
end
