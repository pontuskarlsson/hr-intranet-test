module Refinery
  module Employees
    class ExpenseClaimsController < ::ApplicationController
      before_filter :find_expense_claim,        except: [:index, :new, :create]
      before_filter :find_all_expense_claims,   only: :index
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @expense_claim in the line below:
        present(@page)
      end

      def new
        @xero_expense_claim = current_refinery_user.xero_expense_claims.build(employee_id: current_refinery_user.employee.try(:id))
        present(@page)
      end

      def create
        @xero_expense_claim = current_refinery_user.xero_expense_claims.build(params[:xero_expense_claim])
        if @xero_expense_claim.save
          flash[:notice] = "Expense Claim '#{ @xero_expense_claim.description }' has been Added"
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        else
          present(@page)
          render action: :new
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @expense_claim in the line below:
        present(@page)
      end

      def update

      end

      def submit
        if @xero_expense_claim.submittable_by?(current_refinery_user)
          if verify_contacts && batch_create_receipt && attach_scanned_receipts && submit_expense_claim
            flash[:notice] = 'Successfully submitted Expense Claim'
          end
        end
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
      end

      def destroy
        if @xero_expense_claim.destroyable_by?(current_refinery_user)
          @xero_expense_claim.destroy
          redirect_to refinery.employees_expense_claims_path
        else
          flash[:alert] = 'Cannot delete a Submitted Expense Claim'
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        end
      end

      def add_resource
        @resource = ::Refinery::Resource.new
      end

      def create_resource
        if create_and_associate_resource
          flash[:notice] = 'Successfully added Scanned Receipts'
        else
          flash[:alert] = 'Failed to add Scanned Receipts'
        end
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
      end

      protected
      def find_all_expense_claims
        @xero_expense_claims = current_refinery_user.employee.xero_expense_claims
      end

      def find_expense_claim
        @xero_expense_claim = ::Refinery::Employees::XeroExpenseClaim.accessible_by_user(current_refinery_user).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to refinery.employees_expense_claims_path
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => '/employees/expense_claims').first
      end


      def verify_contacts
        # First build an array containing all contacts of the receipts that do
        # not have a guid saved.
        xero_contacts = []
        @xero_expense_claim.xero_receipts.includes(:xero_contact).each do |xero_receipt|
          if xero_receipt.xero_contact.guid.blank?
            xero_contacts << xero_receipt.xero_contact
          end
        end

        if xero_contacts.any?
          # Loops through each contact and include it in a batch save to Xero
          built_contacts = []
          client.Contact.batch_save do
            xero_contacts.each do |xero_contact|
              built_contacts << client.Contact.build(name: xero_contact.name)
            end
          end

          # Goes through the created records to associate the new guids
          built_contacts.each do |contact|
            if contact.contact_id.present?
              xero_contact = ::Refinery::Employees::XeroContact.find_by_name!(contact.name)
              xero_contact.guid = contact.contact_id
              xero_contact.save!
            end
          end
        end

        true

      rescue ::StandardError => e
        flash[:alert] = 'Something went wrong while verifying Contacts'
        false
      end

      def batch_create_receipt
        active_tracking_categories = ::Refinery::Employees::XeroTrackingCategory.active

        built_receipts = {}
        client.Receipt.batch_save do
          @xero_expense_claim.xero_receipts.each do |xero_receipt|
            if xero_receipt.guid.blank? # Has not been submitted yet
              receipt = client.Receipt.build( date: xero_receipt.date )
              receipt.contact = client.Contact.build(name: xero_receipt.xero_contact.name)
              receipt.user = client.User.build(user_id: xero_receipt.employee.xero_guid)
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

      rescue ::StandardError => e
        flash[:alert] = 'Something went wrong while submitting Receipts'
        false
      end

      def attach_scanned_receipts
        receipt_guid = @xero_expense_claim.xero_receipts.first.guid
        @xero_expense_claim.xero_expense_claim_attachments.each do |xero_expense_claim_attachment|
          if xero_expense_claim_attachment.guid.blank? # Has not been submitted yet
            attachment = client.Receipt.attach_file(
                receipt_guid,
                xero_expense_claim_attachment.resource.file.name,
                xero_expense_claim_attachment.resource.file.tempfile.path,
                xero_expense_claim_attachment.resource.file.mime_type)
            if attachment.attachment_id.present? && attachment.attachment_id != '00000000-0000-0000-0000-000000000000'
              xero_expense_claim_attachment.guid = attachment.attachment_id
              xero_expense_claim_attachment.save!
            end
          end
        end

        @xero_expense_claim.xero_expense_claim_attachments(true).all? { |a| a.guid.present? }

      rescue ::StandardError => e
        flash[:alert] = 'Something went wrong while attaching scanned receipts'
        false
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

        true

      rescue ::StandardError => e
        flash[:alert] = 'Something went wrong while submitting Expense Claims'
        false
      end

      def client
        @xero_client ||= ::Refinery::Employees::XeroClient.new
        @xero_client.client
      end

      def create_and_associate_resource
        begin
          XeroExpenseClaimAttachment.transaction do
            @resources = ::Refinery::Resource.create_resources(params[:resource])
            @resource = @resources.detect { |r| r.valid? } || (raise ::ActiveRecord::RecordNotSaved)

            @xero_expense_claim.xero_expense_claim_attachments.create!(resource_id: @resource.id)

            true
          end
        rescue ::ActiveRecord::RecordNotSaved
          false
        end
      end

    end
  end
end
