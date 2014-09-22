module Refinery
  module SalesOrders
    class SalesOrdersController < ::ApplicationController

      before_filter :find_all_sales_orders
      before_filter :find_page

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

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/sales_orders").first
      end

    end
  end
end
