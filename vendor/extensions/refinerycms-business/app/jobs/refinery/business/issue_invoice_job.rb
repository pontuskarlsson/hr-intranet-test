module Refinery
  module Business
    class IssueInvoiceJob < Struct.new(:invoice_id)

      attr_reader :invoice

      # def enqueue(job)
      #
      # end

      def perform
        ActiveRecord::Base.transaction do
          @invoice = ::Refinery::Business::Invoice.find invoice_id
          account = invoice.account
          xero_authorization = account.omni_authorizations.xero.first

          syncer = Refinery::Business::Xero::Syncer.new account, xero_authorization

          invoice.status = 'AUTHORISED'
          invoice.managed_status = 'authorised'

          syncer.push_invoice invoice

          raise syncer.errors.join(', ') if syncer.errors.any?
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
        @invoice.notify :'refinery/business/billing_accounts', key: 'invoice.issued'
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
