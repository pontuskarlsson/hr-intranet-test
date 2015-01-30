module Refinery
  module Marketing
    class MarketingController < ::ApplicationController
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @contact in the line below:
        present(@page)
      end

      protected

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/marketing").first
      end

    end
  end
end
