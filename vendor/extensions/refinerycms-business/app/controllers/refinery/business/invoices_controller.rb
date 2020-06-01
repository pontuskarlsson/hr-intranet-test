module Refinery
  module Business
    class InvoicesController < BusinessController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INVOICES_URL

      allow_page_roles ROLE_INTERNAL_FINANCE

      before_action :find_invoices, only: [:index]
      before_action :find_invoice,  except: [:index, :new, :create]

      # Form accessor helper methods
      helper_method :invoice_billables_form, :invoice_items_build_form, :invoice_form, :invoice_status_form

      def index
        @invoices = @invoices.from_params(params)

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
          format.pdf { render statement_pdf_options }
        end
      end

      def update
        if invoice_form_saved?
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
        @invoice_billables_form ||= InvoiceBillablesForm.new_in_model(@invoice, params[:invoice], current_refinery_user)
      end

      def invoice_items_build_params
        if params[:invoice_items_build_form]
          params[:invoice_items_build_form]

        elsif !@invoice.invoice_items.exists? && @invoice.company.present? && @invoice.company.plans.active.exists?
          @invoice.company.plans.active.first.invoice_params
        end
      end

      def invoice_items_build_form
        @invoice_items_build_form ||= InvoiceItemsBuildForm.new_in_model(@invoice, invoice_items_build_params, current_refinery_user)
      end

      def invoice_form
        @invoice_form ||= InvoiceForm.new_in_model(@invoice, params[:invoice], current_refinery_user)
      end

      def invoice_status_form
        @invoice_status_form ||= InvoiceStatusForm.new_in_model(@invoice, params[:invoice], current_refinery_user)
      end

      def invoice_form_saved?
        if params[:set_status] == '1'
          invoice_status_form_save
        else
          invoice_form.save
        end
      end
      
      # A method that tries to update the status and if successful, might have some
      # follow up actions on the status change that requires controller context (report generation)
      def invoice_status_form_save
        managed_status_before = @invoice.managed_status
        
        if invoice_status_form.save
          if invoice_status_form.invoice.managed_status_is_approved? && managed_status_before != 'approved'
            create_pdf_statement
          end
          
          true
        else
          false
        end
      end
      
      def create_pdf_statement
        pdf_html = render_to_string statement_pdf_options
        resource = create_resource_from_content pdf_html, @invoice.statement_file_name, {
            ROLE_EXTERNAL => { company_id: @invoice.company_id},
            ROLE_INTERNAL => { company_id: @invoice.company_id},
        }
        document = @invoice.company.documents.create!(
            resource_id: resource.id,
            document_type: @invoice.receipt? ? 'receipt' : 'invoice'
        )
        @invoice.statement = document
        @invoice.save!

      rescue ActiveRecord::RecordNotSaved => e
        ErrorMailer.error_email(e).deliver_later
        false
      end
      
      def statement_pdf_options
        {
            pdf: @invoice.statement_file_name,
            formats: :pdf,
            template: 'refinery/business/invoices/statement',
            layout: 'pdf/document_layout',
            header: { spacing: 5, html: { template: 'pdf/invoices/statement_header', layout: 'pdf/header_layout', locals: { company: @invoice.company } } },
            footer: { spacing: 5, html: { template: 'pdf/invoices/statement_footer', layout: 'pdf/footer_layout', locals: { account: @invoice.account } } },
            margin: { top: 68, bottom: 32, right: 10, left: 20 }
        }
      end

    end
  end
end
