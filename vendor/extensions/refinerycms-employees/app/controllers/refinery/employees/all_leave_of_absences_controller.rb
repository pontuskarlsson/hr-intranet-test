module Refinery
  module Employees
    class AllLeaveOfAbsencesController < ::ApplicationController
      before_filter :find_page

      def index
        @employees = ::Refinery::Employees::Employee.current
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end


      protected

      def find_page
        @page = ::Refinery::Page.where(:link_url => '/employees/all_leave_of_absences').first
      end

    end
  end
end
