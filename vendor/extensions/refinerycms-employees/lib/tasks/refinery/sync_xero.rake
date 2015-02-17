namespace :hr_intranet do

  task sync_xero: :environment do
    puts 'Synchronising Expense Claim status with Xero'

    client = Refinery::Employees::XeroClient.new.client

    # Retrieved all the Expense Claims that have been submitted but not yet paid
    Refinery::Employees::XeroExpenseClaim.pending_in_xero.each do |xero_expense_claim|

      # Wraps it all in a transaction to make sure nothing is being partially updated
      begin
        Refinery::Employees::XeroExpenseClaim.transaction do

          # Updates the status of the Expense Claim
          expense_claim = client.ExpenseClaim.find(xero_expense_claim.guid)
          xero_expense_claim.status           = expense_claim.status
          xero_expense_claim.updated_date_utc = expense_claim.updated_date_utc
          xero_expense_claim.total            = expense_claim.total
          xero_expense_claim.amount_due       = expense_claim.amount_due
          xero_expense_claim.amount_paid      = expense_claim.amount_paid
          xero_expense_claim.payment_due_date = expense_claim.payment_due_date
          xero_expense_claim.save!

          # Updates the status of all the Receipts
          xero_expense_claim.xero_receipts.each do |xero_receipt|
            receipt = expense_claim.receipts.detect { |r| r.receipt_id == xero_receipt.guid }
            xero_receipt.status = receipt.status
            xero_receipt.save!
          end

        end
      rescue ActiveRecord::ActiveRecordError => e
        ::ErrorMailer.error_email(e).deliver_now
      end

    end

    puts 'Done Synchronising'
  end

end
