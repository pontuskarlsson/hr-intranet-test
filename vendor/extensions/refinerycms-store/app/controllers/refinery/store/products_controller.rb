module Refinery
  module Store
    class ProductsController < ::ApplicationController

      before_filter :find_all_products
      before_filter :find_page

      def show
        @product = Product.find(params[:id])

        present(@page)
      end

      protected

      def find_all_products
        @products = Product.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/store/products").first
      end

    end
  end
end
