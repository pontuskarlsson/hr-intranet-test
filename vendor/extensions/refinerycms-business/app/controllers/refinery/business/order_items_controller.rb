module Refinery
  module Business
    class OrderItemsController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_ORDERS_URL
      allow_page_roles ROLE_INTERNAL_FINANCE

      before_filter :find_order
      before_filter :find_order_items,  only: [:index]
      before_filter :find_order_item,   except: [:index, :new, :create]

      def index
        @order_items = @order_items.where(filter_params).order(:line_item_number)
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @order in the line below:
        present(@page)
      end

      protected

      def orders_scope
        @orders ||=
            if page_role? ROLE_INTERNAL_FINANCE
              Refinery::Business::Order.where(nil)
            else
              Refinery::Business::Order.where('1=0')
            end
      end

      def find_order
        @order = orders_scope.find(params[:order_id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def find_order_items
        @order_items = @order.order_items
      end

      def find_order_item
        @order_item = @order.order_items.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:buyer_id, :seller_id, :order_type])
      end

    end
  end
end
