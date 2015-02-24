module Refinery
  module Employees
    class ReceiptsController < ::ApplicationController
      before_filter :find_expense_claim
      before_filter :find_receipt,      except: [:new, :create]

      helper_method :active_tracking_categories

      def new
        @xero_receipt = @xero_expense_claim.xero_receipts.build
      end

      def create
        @xero_receipt = @xero_expense_claim.xero_receipts.build(params[:xero_receipt])
        @xero_receipt.employee = @xero_expense_claim.employee
        @xero_receipt.total = @xero_receipt.xero_line_items.inject(0) { |sum, li| sum += li.line_total }
        if @xero_receipt.save
          @xero_expense_claim.total = @xero_expense_claim.xero_receipts(true).inject(0) { |sum, rec| sum += rec.total }
          @xero_expense_claim.save

          flash[:notice] = "Receipt from '#{ @xero_receipt.contact_name }' has been successfully Added"
          if params[:add_another]
            redirect_to refinery.new_employees_expense_claim_receipt_path(@xero_expense_claim)
          else
            redirect_to refinery.employees_expense_claim_receipt_path(@xero_expense_claim, @xero_receipt)
          end
        else
          render action: :new
        end
      end

      def show
      end

      def edit
        unless @xero_receipt.editable?
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        end
      end

      def update
        if @xero_receipt.editable?
          if @xero_receipt.update_attributes(params[:xero_receipt])
            # Need to update the total in case there was modified line items.
            @xero_receipt.total = @xero_receipt.xero_line_items(true).inject(0) { |sum, li| sum += li.line_total }
            @xero_receipt.save

            # Need to update the total on the expense claim as well in case there was modified line items.
            @xero_expense_claim.total = @xero_expense_claim.xero_receipts(true).inject(0) { |sum, rec| sum += rec.total }
            @xero_expense_claim.save

            flash[:notice] = 'Receipt has been successfully updated'

            redirect_to refinery.employees_expense_claim_receipt_path(@xero_expense_claim, @xero_receipt)
          else
            render action: :edit
          end
        else
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        end
      end

      def destroy
        if @xero_receipt.destroy
          @xero_expense_claim.total = @xero_expense_claim.xero_receipts(true).inject(0) { |sum, rec| sum += rec.total }
          @xero_expense_claim.save
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        else
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        end
      end

      protected
      def find_expense_claim
        @xero_expense_claim = ::Refinery::Employees::XeroExpenseClaim.accessible_by_user(current_refinery_user).find(params[:expense_claim_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to refinery.employees_expense_claims_path
      end

      def find_receipt
        @xero_receipt = @xero_expense_claim.xero_receipts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
      end

      def active_tracking_categories
        @_active_tracking_categories ||= ::Refinery::Employees::XeroTrackingCategory.active
      end

    end
  end
end
