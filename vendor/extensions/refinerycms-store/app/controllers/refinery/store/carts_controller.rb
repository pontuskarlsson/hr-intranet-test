module Refinery
  module Store
    class CartsController < ::ApplicationController
      before_filter :authenticate_refinery_user!
      before_filter :find_page, only: [:show]

      def show
        cart_ids = $redis.smembers current_user_cart
        @cart_products = Product.find(cart_ids)

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @order in the line below:
        present(@page)
      end

      def add
        $redis.sadd current_user_cart, params[:product_id]
        render json: current_refinery_user.cart_count, status: 200
      end

      def remove
        $redis.srem current_user_cart, params[:product_id]
        render json: current_refinery_user.cart_count, status: 200
      end

      def place_order
        if create_order
          flash[:notice] = 'Successfully placed the Order'
          redirect_to refinery.store_root_path
        else
          flash[:alert] = 'Failed to place Order'
          redirect_to refinery.store_cart_path
        end
      end

      protected

      def current_user_cart
        "cart#{current_refinery_user.id}"
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/store/cart").first
      end

      def create_order
        Order.transaction do
          cart_ids = $redis.smembers current_user_cart
          @cart_products = Product.find(cart_ids).group_by(&:retailer_id)

          @cart_products.each do |retailer_id, products|
            order = current_refinery_user.store_orders.create!(retailer_id: retailer_id)
            products.each do |product|
              order.order_items.create!(product_id: product.id, quantity: 1)
            end

            order.total_price = order.order_items.sum(&:sub_total_price)
            order.save!
          end

          cart_ids.each do |cid|
            $redis.srem current_user_cart, cid
          end

          true
        end
      rescue ActiveRecord::RecordNotSaved
        false
      end

    end
  end
end
