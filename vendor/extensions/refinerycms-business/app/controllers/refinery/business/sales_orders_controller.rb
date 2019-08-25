module Refinery
  module Business
    class SalesOrdersController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_SALES_ORDERS_URL
      allow_page_roles ROLE_INTERNAL

      before_filter :find_sales_orders,   only: [:index]
      before_filter :find_sales_order,    except: [:index, :new, :create]

      def index
        @sales_order = SalesOrder.new
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @sales_order in the line below:
        present(@page)
      end

      def show
        @sales_order = SalesOrder.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @sales_order in the line below:
        present(@page)
      end

      def create
        @sales_order = SalesOrder.new(sales_order_params)
        if @sales_order.save
          redirect_to refinery.business_sales_order_path @sales_order
        else
          find_sales_orders
          present(@page)
          render :index
        end
      end

    protected

      def sales_order_scope
        @sales_orders ||= SalesOrder.for_user_roles(current_authentication_devise_user, @auth_role_titles)
      end

      def find_sales_orders
        sales_order_scope
      end

      def find_sales_order
        @sales_order = sales_order_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def sales_order_params
        params.require(:sales_order).permit(:name)
      end

    end
  end
end
