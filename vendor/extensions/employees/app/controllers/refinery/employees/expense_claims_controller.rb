module Refinery
  module Employees
    class ExpenseClaimsController < ::ApplicationController
      before_filter :find_employee
      before_filter :find_expense_claim,        except: [:index, :new, :create]
      before_filter :find_all_expense_claims,   only: :index
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def new
        @xero_expense_claim = @employee.xero_expense_claims.build
        present(@page)
      end

      def create
        @xero_expense_claim = @employee.xero_expense_claims.build(params[:xero_expense_claim])
        if @xero_expense_claim.save
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        else
          present(@page)
          render action: :new
        end
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @employee in the line below:
        present(@page)
      end

      def update

      end

      def submit
        if @xero_expense_claim.submittable?
          if verify_contacts && batch_create_receipt #&& submit_expense_claim
            redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
          end
        end
      end

      def destroy
        if @xero_expense_claim.status == 'Not-Submitted'
          @xero_expense_claim.destroy
          redirect_to refinery.employees_expense_claims_path
        else
          flash[:alert] = 'Cannot delete a Submitted Expense Claim'
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        end
      end

      protected
      def find_employee
        @employee = current_refinery_user.employee
        redirect_to '/' if @employee.nil?
      end

      def find_all_expense_claims
        @xero_expense_claims = @employee.xero_expense_claims
      end

      def find_expense_claim
        @xero_expense_claim = @employee.xero_expense_claims.find(params[:id])
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

      rescue ActiveRecord::StandardError => e
        flash[:alert] = e.message
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)

        false
      end

      def batch_create_receipt
        built_receipts = {}
        client.Receipt.batch_save do
          @xero_expense_claim.xero_receipts.each do |xero_receipt|
            if xero_receipt.guid.blank? # Has not been submitted yet
              receipt = client.Receipt.build( date: xero_receipt.date )
              receipt.contact = client.Contact.build(name: xero_receipt.xero_contact.name)
              receipt.user = client.User.build(user_id: xero_receipt.employee.xero_guid)
              xero_receipt.xero_line_items.each do |xero_line_item|
                receipt.add_line_item(
                    description:  xero_line_item.description,
                    unit_amount:  xero_line_item.unit_amount,
                    quantity:     xero_line_item.quantity,
                    account_code: xero_line_item.xero_account.code
                )
              end
              built_receipts[receipt] = xero_receipt
            end
          end
        end

        # Goes through the created records to associate the new guids
        built_receipts.each_pair do |receipt, xero_receipt|
          if receipt.receipt_id.present?
            xero_receipt.guid = receipt.receipt_id
            xero_receipt.status = ::Refinery::Employees::XeroReceipt::STATUS_SUBMITTED
            xero_receipt.save!
          end
        end

        true

      rescue ::StandardError => e
        flash[:alert] = e.message
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)

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
        flash[:alert] = e.message
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)

        false
      end

      def client
        @client ||= ::Refinery::Employees::XeroClient.client
      end

    end
  end
end
