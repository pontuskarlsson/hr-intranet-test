module Refinery
  module Business
    class InvoicesController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INVOICES_URL
      allow_page_roles ROLE_INTERNAL_FINANCE

      before_filter :find_invoices, only: [:index]
      before_filter :find_invoice,  except: [:index, :new, :create]

      helper_method :invoice_billables_form

      def index
        @invoices = @invoices.from_params(params).order(updated_date_utc: :desc)
        present(@page)
      end

      def show
        present(@page)
      end

      def add_billables
        if invoice_billables_form.save
          flash[:notice] = 'Successfully added Billables to Invoice'
          if params[:redirect_to].present?
            redirect_to params[:redirect_to], status: :see_other
          else
            redirect_to refinery.business_invoice_path(@invoice), status: :see_other
          end
        else
          present(@page)
          render :show
        end
      end

      protected

      def invoices_scope
        @invoices ||=
            if page_role? ROLE_INTERNAL_FINANCE
              Refinery::Business::Invoice.where(nil)
            else
              Refinery::Business::Invoice.where('1=0')
            end
      end

      def find_invoices
        @invoices = invoices_scope.where(filter_params)
      end

      def find_invoice
        @invoice = invoices_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def filter_params
        params.permit([:company_id, :project_id, :account_id, :contact_id, :status, :invoice_type])
      end

      def invoice_billables_form
        @invoice_billables_form ||= InvoiceBillablesForm.new_in_model(@invoice, params[:invoice], current_authentication_devise_user)
      end

    end
  end
end
