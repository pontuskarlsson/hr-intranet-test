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
      verify_contacts
      batch_create_receipt
      submit_expense_claim
    end
    redirect_to action: :show
  end

  def destroy
    if @expense_claim.status == 'Not-Submitted'
      @expense_claim.destroy
      redirect_to '/employee/expense-claims'
    else
      flash[:alert] = 'Cannot delete a Submitted Expense Claim'
      redirect_to action: :show
    end
  end

private
  def find_expense_claim
    @expense_claim = current_refinery_user.expense_claims.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :show
  end

  def verify_contacts
    # First build an array containing all contacts of the receipts that do
    # not have a guid saved.
    contacts = []
    @expense_claim.receipts.includes(:contact).each do |receipt|
      if receipt.contact.guid.blank?
        contacts << receipt.contact
      end
    end

    if contacts.any?
      # Loops through each contact and include it in a batch save to Xero
      xero_contacts = []
      client.Contact.batch_save do
        contacts.each do |contact|
          xero_contacts << client.Contact.build(name: contact.name)
        end
      end

      # Goes through the created records to associate the new guids
      xero_contacts.each do |xero_contact|
        if xero_contact.contact_id.present?
          contact = ::Contact.find_by_name!(xero_contact.name)
          contact.guid = xero_contact.contact_id
          contact.save!
        end
      end
    end

  rescue ActiveRecord::StandardError => e
    flash[:alert] = e.message
    redirect_to action: :show
  end

  def batch_create_receipt
    xero_receipts = {}
    client.Receipt.batch_save do
      @expense_claim.receipts.each do |receipt|
        if receipt.guid.blank? # Has not been submitted yet
           xero_receipt = client.Receipt.build( date: receipt.date )
           xero_receipt.contact = client.Contact.build(name: receipt.contact.name)
           xero_receipt.user = client.User.build(user_id: receipt.user.xero_guid)
           receipt.line_items.each do |line_item|
             xero_receipt.add_line_item(
                 description: line_item.description,
                 unit_amount: line_item.unit_amount,
                 quantity: line_item.quantity,
                 account_code: line_item.account.code
             )
           end
           xero_receipts[xero_receipt] = receipt
        end
      end
    end

    # Goes through the created records to associate the new guids
    xero_receipts.each_pair do |xero_receipt, receipt|
      if xero_receipt.receipt_id.present?
        receipt.guid = xero_receipt.receipt_id
        receipt.status = Receipt::STATUS_SUBMITTED
        receipt.save!
      end
    end

  rescue ActiveRecord::StandardError => e
    flash[:alert] = e.message
    redirect_to action: :show
  end

  def submit_expense_claim
    xero_expense_claim = client.ExpenseClaim.build
    xero_expense_claim.user = client.User.build(user_id: @expense_claim.user.xero_guid)
    @expense_claim.receipts.each do |receipt|
      xero_expense_claim.add_receipt(receipt_id: receipt.guid)
    end
    xero_expense_claim.save

    if xero_expense_claim.expense_claim_id.present?
      @expense_claim.guid = xero_expense_claim.expense_claim_id
      @expense_claim.status = ExpenseClaim::STATUS_SUBMITTED
      @expense_claim.save!
    end

  rescue ActiveRecord::StandardError => e
    flash[:alert] = e.message
    redirect_to action: :show
  end

  def client
    @client ||= XeroClient.client
  end

end
