module Refinery
  module Employees
    module Admin
      class EmployeesController < ::Refinery::AdminController

        crudify :'refinery/employees/employee',
                :title_attribute => 'employee_no',
                order: 'employee_no ASC'

        helper_method :active_tracking_categories

        def load_xero_guids
          session[:xero_guids] = load_xero_guids_from_xero
          redirect_to refinery.edit_employees_admin_employee_path(params[:id])
        end

        protected
        def active_tracking_categories
          @_active_tracking_categories ||= ::Refinery::Employees::XeroTrackingCategory.active
        end

        def load_xero_guids_from_xero
          ::Refinery::Employees::XeroClient.new('Happy Rabbit Limited').load_xero_guids
        rescue StandardError => e
          []
        end

        def employee_params
          params.require(:employee).permit(
              :user_id, :employee_no, :full_name, :id_no, :profile_image_id, :title, :position,
              :xero_guid, :xero_guid_field, :user_name, :default_tracking_options, :reporting_manager_id,
              :contact_ref, :birthday, :emergency_contact
          )
        end

      end
    end
  end
end
