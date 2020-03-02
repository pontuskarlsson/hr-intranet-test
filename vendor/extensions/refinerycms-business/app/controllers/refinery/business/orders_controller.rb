module Refinery
  module Business
    class OrdersController < BusinessController
      set_page PAGE_ORDERS_URL

      allow_page_roles ROLE_INTERNAL_FINANCE

      before_action :find_orders, only: [:index]
      before_action :find_order,  except: [:index, :import, :new, :create]

      def index
        @orders = @orders.where(filter_params).order(updated_date_utc: :desc)

        respond_to do |format|
          format.html { present(@page) }
          format.json
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @order in the line below:
        present(@page)
      end

      protected

      def find_orders
        @orders = orders_scope
      end

      def find_order
        @order = orders_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:buyer_id, :seller_id, :order_type]).to_h
      end

    end
  end
end
