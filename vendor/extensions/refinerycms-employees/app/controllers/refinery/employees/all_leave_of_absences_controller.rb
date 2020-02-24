module Refinery
  module Employees
    class AllLeaveOfAbsencesController < ::ApplicationController
      before_action :find_page

      def index
        @employees = ::Refinery::Employees::Employee.current
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end


      protected

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/employees/all_leave_of_absences', current_refinery_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
