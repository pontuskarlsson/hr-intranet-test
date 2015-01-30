module Refinery
  module Employees
    class DashboardController < ::ApplicationController
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      protected

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/employees").first
      end

    end
  end
end
