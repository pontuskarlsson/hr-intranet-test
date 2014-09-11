class ReceiptsController < ApplicationController
  before_filter :find_expense_claim
  before_filter :find_receipt,      except: [:new, :create]

  def new
    @receipt = @expense_claim.receipts.build
  end

  def create
    @receipt = @expense_claim.receipts.build(params[:receipt])
    @receipt.user = @expense_claim.user
    @receipt.total = @receipt.line_items.inject(0) { |sum, li| sum += li.line_total }
    if @receipt.save
      @expense_claim.total = @expense_claim.receipts(true).inject(0) { |sum, rec| sum += rec.total }
      @expense_claim.save
      redirect_to expense_claim_path(@expense_claim)
    else
      render action: :new
    end
  end

private
  def find_expense_claim
    @expense_claim = current_refinery_user.expense_claims.find(params[:expense_claim_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/'
  end

  def find_receipt
    @receipt = @expense_claim.receipts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/'
  end

end
