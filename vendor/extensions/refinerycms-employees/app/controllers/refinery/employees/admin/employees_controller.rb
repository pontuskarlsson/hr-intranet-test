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
          session[:xero_guids] = load_xero_guids
          redirect_to refinery.edit_employees_admin_employee_path(params[:id])
        end

        protected
        def active_tracking_categories
          @_active_tracking_categories ||= ::Refinery::Employees::XeroTrackingCategory.active
        end

        def load_xero_guids
          ::Refinery::Employees::XeroClient.new('Happy Rabbit Limited').load_xero_guids
        rescue StandardError => e
          []
        end

      end
    end
  end
end
