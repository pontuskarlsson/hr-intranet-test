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
        @xero_expense_claim = current_authentication_devise_user.xero_expense_claims.build(employee_id: current_authentication_devise_user.employee.try(:id))
        present(@page)
      end

      def create
        @xero_expense_claim = current_authentication_devise_user.xero_expense_claims.build(xero_expense_claim_params)
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

      def edit
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @expense_claim in the line below:
        present(@page)
      end

      def update
        if @xero_expense_claim.update_attributes(xero_expense_claim_params)
          flash[:notice] = "Expense Claim '#{ @xero_expense_claim.description }' has been Updated"
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        else
          present(@page)
          render action: :edit
        end
      end

      def submit
        if @xero_expense_claim.submittable_by?(current_authentication_devise_user)
          if @xero_expense_claim.submit! #verify_contacts && batch_create_receipt && attach_scanned_receipts && submit_expense_claim
            flash[:notice] = 'Expense Claim is being submitted, it can take several minutes to complete.'
          else
            flash[:notice] = 'Failed to submit the Expense Claim'
          end

        else
          flash[:notice] = 'You are not authorized to submit this Expense Claim.'
        end
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
      end

      def destroy
        if @xero_expense_claim.destroyable_by?(current_authentication_devise_user)
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

      def destroy_resource
        if destroy_attachment_and_resource
          flash[:notice] = 'Successfully removed Receipt'
        else
          flash[:alert] = 'Failed to remove Receipt'
        end
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
      end

      protected
      def find_all_expense_claims
        @xero_expense_claims = current_authentication_devise_user.employee.xero_expense_claims
      end

      def find_expense_claim
        #@xero_expense_claim = ::Refinery::Employees::XeroExpenseClaim.accessible_by_user(current_authentication_devise_user).find(params[:id])
        @xero_expense_claim = ::Refinery::Employees::XeroExpenseClaim.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to refinery.employees_expense_claims_path
      end

      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/employees/expense_claims', current_authentication_devise_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def create_and_associate_resource
        begin
          XeroExpenseClaimAttachment.transaction do
            @resources = ::Refinery::Resource.create_resources(params[:resource])
            (resources = @resources.select(&:valid?)).any? || (raise ::ActiveRecord::RecordNotSaved)

            resources.each do |resource|
              @xero_expense_claim.xero_expense_claim_attachments.create!(resource_id: resource.id)
            end

            @resource = resources.first

            true
          end
        rescue ::ActiveRecord::RecordNotSaved
          false
        end
      end

      def destroy_attachment_and_resource
        begin
          XeroExpenseClaimAttachment.transaction do
            xero_expense_claim_attachment = @xero_expense_claim.xero_expense_claim_attachments.find params[:resource_id]
            xero_expense_claim_attachment.resource.destroy
            xero_expense_claim_attachment.destroy
            true
          end
        rescue ::ActiveRecord::RecordNotSaved
          false
        end
      end

      def xero_expense_claim_params
        params.require(:xero_expense_claim).permit(
            :guid, :status, :total, :amount_due, :amount_paid, :payment_due_date, :reporting_date,
            :updated_date_utc, :description, :employee_id
        )
      end

    end
  end
end
