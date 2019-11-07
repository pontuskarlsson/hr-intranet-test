namespace :refinery do
  namespace :employees do

    task sync_xero: :environment do
      puts 'Synchronising Expense Claim status with Xero'

      client = Refinery::Employees::XeroClient.new('Happy Rabbit Limited').client

      # Retrieved all the Expense Claims that have been submitted but not yet paid
      Refinery::Employees::XeroExpenseClaim.pending_in_xero.each do |xero_expense_claim|

        # Wraps it all in a transaction to make sure nothing is being partially updated
        begin
          Refinery::Employees::XeroExpenseClaim.transaction do

            # Updates the status of the Expense Claim
            expense_claim = client.ExpenseClaim.find(xero_expense_claim.guid)
            xero_expense_claim.status           = expense_claim.status
            if xero_expense_claim.status == Refinery::Employees::XeroExpenseClaim::STATUS_DELETED
              xero_expense_claim.guid = nil
              xero_expense_claim.xero_expense_claim_attachments.each do |attachment|
                attachment.guid = nil
                attachment.save!
              end
            else
              xero_expense_claim.updated_date_utc = expense_claim.updated_date_utc
              xero_expense_claim.total            = expense_claim.total
              xero_expense_claim.amount_due       = expense_claim.amount_due
              xero_expense_claim.amount_paid      = expense_claim.amount_paid
              xero_expense_claim.payment_due_date = expense_claim.payment_due_date
            end
            xero_expense_claim.save!

            # Updates the status of all the Receipts
            xero_expense_claim.xero_receipts.each do |xero_receipt|
              if (receipt = expense_claim.receipts.detect { |r| r.receipt_id == xero_receipt.guid }).present?
                xero_receipt.status = receipt.status
              else
                xero_receipt.status = Refinery::Employees::XeroReceipt::STATUS_DELETED
                xero_receipt.guid = nil
              end
              xero_receipt.save!
            end

          end
        rescue ActiveRecord::ActiveRecordError => e
          ::ErrorMailer.error_email(e).deliver

        rescue Xeroizer::ObjectNotFound => e
          ::ErrorMailer.error_email(e).deliver
        end

      end

      puts 'Synchronising Tracking Categories'
      tracking_categories = client.TrackingCategory.all
      # If a XeroTrackingCategory is Active but not found in Xero, change it to Archived
      Refinery::Employees::XeroTrackingCategory.active.where('guid NOT IN (?)', tracking_categories.map(&:tracking_category_id) << -1).each do |xero_expense_claim|
        xero_expense_claim.status = Refinery::Employees::XeroTrackingCategory::STATUS_ARCHIVED
        xero_expense_claim.save
      end

      # Start with updating the archived Categories, that way we avoid triggering validation
      # errors by trying to activate a third Category before the Category it replaced has
      # been archived
      tracking_categories.select { |tc|
        tc.status ==  Refinery::Employees::XeroTrackingCategory::STATUS_ARCHIVED
      }.each do |tracking_category|
        xero_expense_claim = Refinery::Employees::XeroTrackingCategory.find_or_initialize_by_guid(tracking_category.tracking_category_id)
        xero_expense_claim.name = tracking_category.name
        xero_expense_claim.status = tracking_category.status
        xero_expense_claim.options = tracking_category.options.map { |option| { guid: option.tracking_option_id, name: option.name } }
        xero_expense_claim.save
      end

      # Now that we have archived everything that should be, we can potentially activate
      # additional categories
      tracking_categories.select { |tc|
        tc.status ==  Refinery::Employees::XeroTrackingCategory::STATUS_ACTIVE
      }.each do |tracking_category|
        xero_expense_claim = Refinery::Employees::XeroTrackingCategory.find_or_initialize_by_guid(tracking_category.tracking_category_id)
        xero_expense_claim.name = tracking_category.name
        xero_expense_claim.status = tracking_category.status
        xero_expense_claim.options = tracking_category.options.map { |option| { guid: option.tracking_option_id, name: option.name } }
        xero_expense_claim.save
      end

      puts 'Synchronising Accounts'
      client.sync_accounts

      puts 'Done Synchronising'
    end

  end
end
