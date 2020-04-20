module Refinery
  module Business
    class PurchasesController < BusinessController
      include Refinery::PageRoles::AuthController

      set_page PAGE_PURCHASES_URL

      layout 'application'

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
        @purchase_form = PurchaseForm.new_in_model(selected_company, {
            qty: params[:qty],
            discount_code: params[:discount_code],
            article_code: 'VOUCHER-QAQC-DAY' # The only one we sell right now
        }, current_refinery_user)
      end

      def create
        @purchase_form = PurchaseForm.new_in_model(selected_company, params[:purchase], current_refinery_user)

        respond_to do |format|
          if @purchase_form.save # Not saved
            format.js
          else
            format.js { render action: :new }
          end
        end
      end

      def success
        flash[:notice] = "Payment was successful. Your credits will be issued shortly."
        redirect_to refinery.business_purchases_path
      end

      def cancel
        flash[:alert] = "Payment was canceled. Please try again if this was a mistake."
        redirect_to refinery.business_purchases_path
      end

      private

      def find_purchases
        @purchases = purchases_scope.where(filter_params)
      end

      def filter_params
        params.permit([:company_id, :status]).to_h
      end

    end
  end
end
