module Refinery
  module Store
    class StoreController < ::ApplicationController
      before_filter :find_retailers
      before_filter :find_products
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @order in the line below:
        present(@page)
      end

      protected

      def find_retailers
        @retailers = Retailer.order(:name)
      end

      def find_products
        @products =
            if params[:retailer_id].present?
              Retailer.find(params[:retailer_id]).products.not_expired
            else
              Product.not_expired
            end

        @products =
            case params[:scope]
              when 'featured' then @products.featured
              #when 'recent' then Product
              #when 'most_popular' then Product
              else @products
            end

      rescue ActiveRecord::RecordNotFound
        flash[:alert] = 'Not a valid Retailer'
        redirect_to refinery.store_root_path
      end

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/store', current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
