module Refinery
  module Business
    class InvoicesController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INVOICES_URL
      allow_page_roles ROLE_INTERNAL_FINANCE

      before_action :find_invoices, only: [:index]
      before_action :find_invoice,  except: [:index, :new, :create]

      helper_method :invoice_billables_form, :invoice_items_build_form

      def index
        @invoices = @invoices.from_params(params).order(updated_date_utc: :desc)

        respond_to do |format|
          format.html { present(@page) }
          format.json {
            render json: @invoices.dt_response(params) if server_side?
          }
        end
      end

      def show
        present(@page)
      end

      def statement
        respond_to do |format|
          format.html { present(@page) }
          format.pdf {
            render pdf: "#{@invoice.account.organisation} #{@invoice.invoice_number}",
                   layout: 'pdf/document_layout',
                   header: { spacing: 5, html: { template: 'pdf/document_header' } },
                   footer: { spacing: 5, html: { template: 'pdf/document_footer', locals: { account: @invoice.account } } },
                   margin: { top: 68, bottom: 32, right: 10, left: 20 }
          }
        end
      end

      def update
        if @invoice.update_attributes(invoice_params)
          flash[:notice] = 'Successfully updated the Invoice'
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

      def build
        if invoice_items_build_form.save
          flash[:notice] = 'Successfully built Invoice Items'
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
              Refinery::Business::Invoice.invoices.where(nil)
            else
              Refinery::Business::Invoice.invoices.where('1=0')
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

      def invoice_params
        params.require(:invoice).permit(:is_managed)
      end

      def filter_params
        params.permit([:company_id, :project_id, :account_id, :contact_id, :status, :invoice_type]).to_h
      end

      def invoice_billables_form
        @invoice_billables_form ||= InvoiceBillablesForm.new_in_model(@invoice, params[:invoice], current_authentication_devise_user)
      end

      def invoice_items_build_form
        @invoice_items_build_form ||= InvoiceItemsBuildForm.new_in_model(@invoice, params[:invoice_items_build_form], current_authentication_devise_user)
      end

    end
  end
end
