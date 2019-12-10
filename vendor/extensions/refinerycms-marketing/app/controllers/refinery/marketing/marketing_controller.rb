module Refinery
  module Marketing
    class MarketingController < ::ApplicationController
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @contact in the line below:
        present(@page)
      end

      protected

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/marketing', current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
