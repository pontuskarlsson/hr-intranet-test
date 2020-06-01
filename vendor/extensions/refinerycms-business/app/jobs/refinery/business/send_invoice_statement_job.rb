module Refinery
  module Business
    class SendInvoiceStatementJob < Struct.new(:invoice_id)

      attr_reader :invoice

      # def enqueue(job)
      #
      # end

      def perform
        ActiveRecord::Base.transaction do
          @invoice = ::Refinery::Business::Invoice.find invoice_id

          renderer = Refinery::Addons::ReportRenderer.new(invoice: @invoice)
          renderer.set_options(
              layout: 'pdf/document_layout',
              header: { spacing: 5, html: { template: 'pdf/invoices/statement_header', layout: 'pdf/header_layout', locals: { company: @invoice.company } } },
              footer: { spacing: 5, html: { template: 'pdf/invoices/statement_footer', layout: 'pdf/footer_layout', locals: { account: @invoice.account } } },
              margin: { top: 68, bottom: 32, right: 10, left: 20 },
              page_size: 'A4'
          )
          pdf_content = renderer.render template: 'refinery/business/invoices/statement'

          resource = create_resource_from pdf_content, @invoice.statement_file_name

          document = @invoice.company.documents.create!(
              resource_id: resource.id,
              document_type: @invoice.receipt? ? 'receipt' : 'invoice'
          )

          @invoice.statement = document
          @invoice.save!
        end
      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        @invoice.notify :'refinery/business/billing_accounts', key: 'invoice.issued'
      end

      def error(job, exception)
        ErrorMailer.error_email(exception).deliver
      end

      # def failure(job)
      #
      # end

      private

      def create_resource_from(file_content, file_name)
        resource = Refinery::Resource.new
        resource.file = file_content
        resource.file.name = file_name
        resource.file_mime_type = resource.file.mime_type
        resource.authorizations_access = Refinery::Resource.access_string_for(
            Refinery::Business::ROLE_EXTERNAL => { company_id: invoice.company_id},
            Refinery::Business::ROLE_INTERNAL => { company_id: invoice.company_id}
        )
        resource.save!
        resource
      end

    end
  end
end
