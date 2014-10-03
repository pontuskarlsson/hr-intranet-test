module Refinery
  module Employees
    class ReceiptsController < ::ApplicationController
      before_filter :find_employee
      before_filter :find_expense_claim
      before_filter :find_receipt,      except: [:new, :create]

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
          redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
        else
          render action: :new
        end
      end

      protected
      def find_employee
        @employee = current_refinery_user.employee
        redirect_to '/' if @employee.nil?
      end

      def find_expense_claim
        @xero_expense_claim = @employee.xero_expense_claims.find(params[:expense_claim_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to refinery.employees_expense_claims_path
      end

      def find_receipt
        @xero_receipt = @xero_expense_claim.xero_receipts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to refinery.employees_expense_claim_path(@xero_expense_claim)
      end

    end
  end
end
