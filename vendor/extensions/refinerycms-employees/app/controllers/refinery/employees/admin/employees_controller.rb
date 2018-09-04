module Refinery
  module Employees
    module Admin
      class EmployeesController < ::Refinery::AdminController

        crudify :'refinery/employees/employee',
                :title_attribute => 'employee_no',
                :xhr_paging => true,
                order: 'employee_no ASC'

        helper_method :active_tracking_categories

        def load_xero_guids
          xero_api_key_file = Refinery::Employees::XeroApiKeyfile.find_by_organisation('Happy Rabbit Limited')
          if (xero_guids = ::Refinery::Employees::XeroClient.new(xero_api_key_file).load_xero_guids).any?
            session[:xero_guids] = xero_guids
          end
          redirect_to refinery.edit_employees_admin_employee_path(params[:id])
        end

        protected
        def active_tracking_categories
          @_active_tracking_categories ||= ::Refinery::Employees::XeroTrackingCategory.active
        end

      end
    end
  end
end
