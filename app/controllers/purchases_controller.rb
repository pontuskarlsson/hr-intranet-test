class PurchasesController < ApplicationController
  layout 'application'

  before_action :authenticate_authentication_devise_user!

  def index

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
    redirect_to purchases_path
  end

  def cancel
    flash[:alert] = "Payment was canceled. Please try again if this was a mistake."
    redirect_to purchases_path
  end

  private

  def purchase_params(allowed = %i(qty article_code discount_code))
    params.require(:purchase).permit(allowed)
  end

end
