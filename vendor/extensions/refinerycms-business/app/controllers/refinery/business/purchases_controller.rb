module Refinery
  module Business
    class PurchasesController < ::ApplicationController
      layout 'application'

      before_action :authenticate_authentication_devise_user!

      before_action :find_purchases, only: [:index]

      def index
        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @purchases.dt_response(params) if server_side?
          }
        end
      end

      def new
        @purchase = Purchase.new(article_code: params[:item], qty: params[:qty], discount_code: params[:discount_code])
        @purchase.article_code = 'VOUCHER-QAQC-DAY' # The only one we sell right now
        @purchase.calculate_cost
      end

      def create
        @purchase = current_authentication_devise_user.purchases.build(purchase_params)

        respond_to do |format|
          if @purchase.save # Not saved
            format.js
          else
            format.js { render action: :new }
          end
        end
      end

      def success
        flash[:info] = "Payment was successful. Your credits will be issued shortly."
        redirect_to refinery.business_purchases_path
      end

      def cancel
        flash[:alert] = "Payment was canceled. Please try again if this was a mistake."
        redirect_to refinery.business_purchases_path
      end

      private

      def purchases_scope
        @purchases = Purchase.for_user_roles(current_authentication_devise_user)
      end

      def find_purchases
        @purchases = purchases_scope.where(filter_params)
      end

      def purchase_params(allowed = %i(qty article_code discount_code))
        params.require(:purchase).permit(allowed)
      end

      def filter_params
        params.permit([:company_id, :status]).to_h
      end

    end
  end
end
