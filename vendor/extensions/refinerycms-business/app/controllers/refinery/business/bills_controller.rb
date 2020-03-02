module Refinery
  module Business
    class BillsController < BusinessController
      set_page PAGE_BILLS_URL

      allow_page_roles ROLE_INTERNAL_FINANCE

      before_action :find_bills, only: [:index]
      before_action :find_bill,  except: [:index, :new, :create]

      helper_method :invoice_billables_form

      def index
        @bills = @bills.from_params(params)

        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @bills.dt_response(params) if server_side?
          }
        end
      end

      def show
        present(@page)
      end

      protected

      def find_bills
        @bills = bills_scope.where(filter_params)
      end

      def find_bill
        @bill = invoices_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def invoice_params
        params.require(:invoice).permit(:is_managed)
      end

      def filter_params
        params.permit([:company_id, :project_id, :account_id, :contact_id, :status, :invoice_type]).to_h
      end

      def invoice_billables_form
        @bill_billables_form ||= InvoiceBillablesForm.new_in_model(@bill, params[:invoice], current_refinery_user)
      end

    end
  end
end
