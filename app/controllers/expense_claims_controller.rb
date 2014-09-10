class ExpenseClaimsController < ApplicationController
  before_filter :find_expense_claim,  except: [:new, :create]

  def new

  end

  def create
    expense_claim = current_refinery_user.expense_claims.build(params[:expense_claim])
    if expense_claim.save
      redirect_to expense_claim_path(expense_claim)
    else

    end
  end

  def show

  end

  def update

  end

  def submit
    if @expense_claim.submittable?
      batch_create_receipt
    end
  end

  def destroy

  end

private
  def find_expense_claim
    @expense_claim = current_refinery_user.expense_claims.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/'
  end


  def batch_create_receipt
    XeroClient.client.Receipt.batch_save do
      @expense_claim.receipts.each do |receipt|
        if receipt.guid.blank? # Has not been submitted yet

          XeroClient.client.Receipt.build( date: receipt.date,  )
        end
      end
    end
  end

end
