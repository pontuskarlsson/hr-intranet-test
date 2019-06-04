module Refinery
  module Business
    class SalesOrdersController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_SALES_ORDERS_URL
      allow_page_roles ROLE_INTERNAL

      before_filter :find_all_sales_orders
      before_filter :find_sales_order, except: [:index, :new, :create]

      def index
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

    protected

      def find_all_sales_orders
        @sales_orders = SalesOrder.order('position ASC')
      end

      def find_sales_order
        @sales_order = SalesOrder.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
