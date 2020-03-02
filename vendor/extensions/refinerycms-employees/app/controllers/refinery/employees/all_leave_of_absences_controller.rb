module Refinery
  module Employees
    class AllLeaveOfAbsencesController < ::Refinery::Employees::ApplicationController
      set_page PAGE_ALL_LOA

      def index
        @employees = ::Refinery::Employees::Employee.current
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

    end
  end
end
