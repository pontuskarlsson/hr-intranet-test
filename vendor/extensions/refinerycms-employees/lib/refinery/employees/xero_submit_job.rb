module Refinery
  module Employees
    class XeroSubmitJob

      def initialize(xero_expense_claim_id)
        @xero_expense_claim_id = xero_expense_claim_id
      end

      def submit
        @xero_expense_claim = ::Refinery::Employees::XeroExpenseClaim.find @xero_expense_claim_id

        begin
          if verify_contacts
            if batch_create_receipt
              if attach_scanned_receipts
                unless submit_expense_claim
                  @xero_expense_claim.status = ::Refinery::Employees::XeroExpenseClaim::STATUS_ERROR
                  @xero_expense_claim.error_reason = 'Failed to Submit Expense Claim'
                  @xero_expense_claim.save
                end

              else
                @xero_expense_claim.status = ::Refinery::Employees::XeroExpenseClaim::STATUS_ERROR
                @xero_expense_claim.error_reason = 'Failed to attach scanned receipts'
                @xero_expense_claim.save
              end

            else
              @xero_expense_claim.status = ::Refinery::Employees::XeroExpenseClaim::STATUS_ERROR
              @xero_expense_claim.error_reason = 'Failed to create receipts'
              @xero_expense_claim.save
            end

          else
            @xero_expense_claim.status = ::Refinery::Employees::XeroExpenseClaim::STATUS_ERROR
            @xero_expense_claim.error_reason = 'Failed to verify contacts'
            @xero_expense_claim.save
          end

        rescue ::StandardError => e
          log_error e, 'Something went wrong'
          @xero_expense_claim.status = ::Refinery::Employees::XeroExpenseClaim::STATUS_ERROR
          @xero_expense_claim.error_reason = e.message
          @xero_expense_claim.save
        end

      rescue ::ActiveRecord::RecordNotFound => e
        # Record has been removed. No need to fail the job, just let it complete and be cleared out.
      end
      handle_asynchronously :submit

      private

      def verify_contacts
        # First build an array containing all contacts of the receipts that do
        # not have a guid saved.
        xero_contacts = @xero_expense_claim.xero_receipts.includes(:xero_contact).inject([]) do |acc, xero_receipt|
          if xero_receipt.xero_contact.guid.blank? && !acc.include?(xero_receipt.xero_contact)
            acc << xero_receipt.xero_contact
          else
            acc
          end
        end

        if xero_contacts.any?
          # Loops through each contact and include it in a batch save to Xero
          built_contacts = []
          result = client.Contact.batch_save do
            xero_contacts.each do |xero_contact|
              built_contacts << client.Contact.build(name: xero_contact.name)
            end
          end

          # If the Batch Save was unsuccessful, then it might be because one of
          # the contacts had already been created previously. The Batch Save does
          # not seem to do a +find_or_create+ call, that's why it can fail. But
          # if we call +save+ directly on the contacts that failed to be created,
          # then it does seem to perform a +find_or_create+.
          unless result
            built_contacts.each do |contact|
              # This contact id is an indication that it could not be created
              contact.save if contact.contact_id == '00000000-0000-0000-0000-000000000000'
            end
          end

          # Goes through the created records to associate the new guids
          built_contacts.each do |contact|
            if contact.contact_id.present? && contact.contact_id != '00000000-0000-0000-0000-000000000000'
              xero_contact = ::Refinery::Employees::XeroContact.find_by_name!(contact.name)
              xero_contact.guid = contact.contact_id
              xero_contact.save!
            end
          end
        end

        true
      end

      def batch_create_receipt
        active_tracking_categories = ::Refinery::Employees::XeroTrackingCategory.active

        built_receipts = {}
        client.Receipt.batch_save do
          @xero_expense_claim.xero_receipts.each do |xero_receipt|
            if xero_receipt.guid.blank? # Has not been submitted yet
              receipt = client.Receipt.build( date: xero_receipt.date )
              receipt.contact = client.Contact.build(name: xero_receipt.xero_contact.name)
              receipt.user = client.User.build(user_id: @xero_expense_claim.employee.xero_guid)
              xero_receipt.xero_line_items.each do |xero_line_item|
                line_item = receipt.add_line_item(
                    description:  xero_line_item.description,
                    unit_amount:  xero_line_item.unit_amount,
                    quantity:     xero_line_item.quantity,
                    account_code: xero_line_item.xero_account.code
                )
                active_tracking_categories.each do |xero_tracking_category|
                  # First make sure that the line item has an option guid for the selected category, then also
                  # make sure that the guid found can be matched to one of the options available for the category
                  if (option_guid = xero_line_item.tracking_categories_and_options[xero_tracking_category.guid]).present? && (option = xero_tracking_category.options.detect { |o| o[:guid] == option_guid }).present?
                    line_item.add_tracking(
                        tracking_category_id: xero_tracking_category.guid,
                        name: xero_tracking_category.name,
                        option: option[:name]
                    )
                  end
                end
              end
              built_receipts[receipt] = xero_receipt
            end
          end
        end

        # Goes through the created records to associate the new guids
        built_receipts.each_pair do |receipt, xero_receipt|
          if receipt.receipt_id.present? && receipt.receipt_id != '00000000-0000-0000-0000-000000000000'
            xero_receipt.guid = receipt.receipt_id
            xero_receipt.status = ::Refinery::Employees::XeroReceipt::STATUS_SUBMITTED
            xero_receipt.save!
          end
        end

        # Only return true if all receipts have a guid
        @xero_expense_claim.xero_receipts(true).all? { |xr| xr.guid.present? }
      end

      def attach_scanned_receipts
        @xero_expense_claim.xero_expense_claim_attachments.each_with_index do |xero_expense_claim_attachment, i|
          receipt_guid = @xero_expense_claim.xero_receipts[i / 5].try(:guid)
          if xero_expense_claim_attachment.guid.blank? # Has not been submitted yet
            attachment = client.Receipt.attach_file(
                receipt_guid,
                "attachment-#{xero_expense_claim_attachment.id}.pdf", # Easiest way to workaround any strange characters in filename
                xero_expense_claim_attachment.resource.file.tempfile.path,
                xero_expense_claim_attachment.resource.file.mime_type)
            if attachment.attachment_id.present? && attachment.attachment_id != '00000000-0000-0000-0000-000000000000'
              xero_expense_claim_attachment.guid = attachment.attachment_id
              xero_expense_claim_attachment.save!
            end
          end
        end

        @xero_expense_claim.xero_expense_claim_attachments(true).all? { |a| a.guid.present? }
      end

      def submit_expense_claim
        expense_claim = client.ExpenseClaim.build
        expense_claim.user = client.User.build(user_id: @xero_expense_claim.employee.xero_guid)
        @xero_expense_claim.xero_receipts.each do |xero_receipt|
          expense_claim.add_receipt(receipt_id: xero_receipt.guid)
        end
        expense_claim.save

        if expense_claim.expense_claim_id.present?
          @xero_expense_claim.guid = expense_claim.expense_claim_id
          @xero_expense_claim.status = ::Refinery::Employees::XeroExpenseClaim::STATUS_SUBMITTED
          @xero_expense_claim.save!
        end
      end

      def client
        @xero_client ||= ::Refinery::Employees::XeroClient.new(::Refinery::Business::Account::HRL)
        @xero_client.client
      end

      def log_error(e, phase)
        puts e.message
        e.backtrace.each do |row|
          puts row
        end
      end

    end
  end
end
