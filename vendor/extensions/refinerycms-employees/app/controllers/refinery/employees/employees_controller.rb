module Refinery
  module Employees
    class EmployeesController < ::ApplicationController

      before_filter :find_all_employees
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def show
        @employee = Employee.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

    protected

      def find_all_employees
        @employees = Employee.current.alphabetical
      end

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/employees/employees', current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
