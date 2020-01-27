class PurchaseController < ApplicationController
  layout 'portal'

  before_action :authenticate_authentication_devise_user!

  has_wizard :purchase_form, new_session_at: :new_purchase, build_instance_at: :create_purchase

  def index
    @user=current_user.email
  end

  def new_purchase
    @qty = params[:qty]
    @item = params[:item]
  end

  def create_purchase
    respond_to do |format|
      if @purchase_form.new_record? # Not saved
        format.js
      else
        #Delayed::Job.enqueue(ReportGeneratorJob.new(current_user.id, @report.id))
        format.js
      end
    end
  end

end
