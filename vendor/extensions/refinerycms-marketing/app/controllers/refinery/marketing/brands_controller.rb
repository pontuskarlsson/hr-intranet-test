module Refinery
  module Marketing
    class BrandsController < ::ApplicationController

      BRANDS_PER_PAGE = 12

      before_filter :find_all_brands
      before_filter :find_page

      helper_method :no_of_pages, :current_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @brand in the line below:
        present(@page)
      end

      def show
        @brand = Brand.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @brand in the line below:
        present(@page)
      end

    protected

      def find_all_brands
        params.delete(:filter) if params[:filter] == 'All'
        @brands_scope = Brand.order('name ASC')
        @brands_scope = @brands_scope.where('name LIKE ?', params[:filter]+'%') if params[:filter]
        @brands = @brands_scope.offset((current_page-1) * BRANDS_PER_PAGE).limit(BRANDS_PER_PAGE)
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/marketing/brands").first
      end

      def no_of_pages
        @_no_of_pages ||= @brands_scope.length / BRANDS_PER_PAGE + ( (@brands_scope.length % BRANDS_PER_PAGE) > 0 ? 1 : 0 )
      end

      def current_page
        @_current_page ||= (params[:page] || 1).to_i
      end

    end
  end
end
