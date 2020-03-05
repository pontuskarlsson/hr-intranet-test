module Refinery
  module Business
    class IssueInvoiceJob < Struct.new(:invoice_id)

      attr_reader :invoice

      # def enqueue(job)
      #
      # end

      def perform
        @invoice = ::Refinery::Business::Invoice.find invoice_id
        account = invoice.account
        xero_authorization = account.omni_authorizations.xero.first

        syncer = Refinery::Business::Xero::Syncer.new account, xero_authorization

        invoice.status = 'AUTHORISED'
        invoice.managed_status = 'authorised'

        syncer.push_invoice invoice

        if syncer.errors.any?
          raise syncer.errors.join(', ')
        else
          invoice.save
        end
      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        @invoice.notify :'refinery/authentication/devise/users', key: 'invoice.issued'
      end

      def error(job, exception)
        ErrorMailer.error_email(exception).deliver
      end

      # def failure(job)
      #
      # end

      private

    end
  end
end
