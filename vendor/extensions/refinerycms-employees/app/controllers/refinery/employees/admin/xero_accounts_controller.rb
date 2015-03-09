module Refinery
  module Employees
    module Admin
      class XeroAccountsController < ::Refinery::AdminController

        # The only actions we use here is index, edit and update
        crudify :'refinery/employees/xero_account',
                :title_attribute => 'code',
                :xhr_paging => true,
                order: 'featured DESC, code ASC'

        def sync_accounts
          if ::Refinery::Employees::XeroClient.new.sync_accounts
            flash[:notice] = 'Xero Accounts successfully synchronised'
          else
            flash[:alert] = 'Something went wrong while synchronising Xero Accounts'
          end
          redirect_to refinery.employees_admin_xero_accounts_path
        end

      end
    end
  end
end
