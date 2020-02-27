module Refinery
  module Marketing
    class LandingPagesController < ::ApplicationController
      layout 'public'

      skip_before_action :authenticate_authentication_devise_user!

      before_action :find_landing_page

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @contact in the line below:
        present(@page)

        template = 'sections'
        render template: "refinery/pages/#{@page&.view_template.presence || template}"
      end

      protected

      def find_landing_page
        @landing_page = ::Refinery::Marketing::LandingPage.find_by!(slug: "/#{params[:landing_page_slug]}")
        @page = @landing_page.page
      end

      def redirect_domain
        unless WWWSubdomain.matches? request
          redirect_to "#{request.protocol}#{WWWSubdomain.domain}#{request.fullpath}"
        end
      end

    end
  end
end
