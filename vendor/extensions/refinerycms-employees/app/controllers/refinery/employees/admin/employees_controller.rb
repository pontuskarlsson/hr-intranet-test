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
          if (xero_guids = ::Refinery::Employees::XeroClient.new.load_xero_guids).any?
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
