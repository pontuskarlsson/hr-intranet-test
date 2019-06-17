module Refinery
  module Business
    class InvoicesController < ::ApplicationController
      include Refinery::PageRoles::AuthController

      set_page PAGE_INVOICES_URL
      allow_page_roles ROLE_INTERNAL_FINANCE

      before_filter :find_invoices, only: [:index]
      before_filter :find_invoice,  except: [:index, :new, :create]

      def index
        @invoices = @invoices.order(updated_date_utc: :desc)
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @invoice in the line below:
        present(@page)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @invoice in the line below:
        present(@page)
      end

      protected

      def invoices_scope
        @invoices ||=
            if page_role? ROLE_INTERNAL_FINANCE
              Refinery::Business::Invoice.active
            else
              Refinery::Business::Invoice.where('1=0')
            end
      end

      def find_invoices
        @invoices = invoices_scope
      end

      def find_invoice
        @invoice = invoices_scope.find(params[:id])
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

    end
  end
end
