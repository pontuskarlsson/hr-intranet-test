module Refinery
  module Employees
    class DashboardController < ::Refinery::Employees::ApplicationController
      set_page '/employees'

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

    end
  end
end
