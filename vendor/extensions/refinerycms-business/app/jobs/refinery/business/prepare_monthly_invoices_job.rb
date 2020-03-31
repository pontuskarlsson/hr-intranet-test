module Refinery
  module Business
    class PrepareMonthlyInvoicesJob < Struct.new(:account_id, :invoice_for_month)

      def enqueue(job)

      end

      def perform
        @account = ::Refinery::Business::Account.find account_id
        @xero_authorization = @account.omni_authorizations.xero.first!
        @client = ::Refinery::Business::Xero::Client.new(@xero_authorization).client

        ::Refinery::Business::Plan.active.each do |plan|
          handle_contact plan.company
          handle_plan plan
        end

        company_ids = ::Refinery::Business::Billable.where(
            invoice_id: nil,
            billable_date: invoice_for_month..invoice_for_month.end_of_month
        ).pluck(:company_id).uniq

        ::Refinery::Business::Company.find(company_ids).each do |company|
          handle_contact company
          handle_no_plan company
        end
      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        notify_finance_team

        ErrorMailer.error_email(errors[0], errors[1..-1]).deliver if errors.any?
      end

      def error(job, exception)
        ErrorMailer.error_email(exception, job.errors).deliver
      end

      # def failure(job)
      #
      # end

      private

      # === handle_contact
      #
      # This method makes sure that a company has a valid Xero contact reference
      # that we can use when creating the Invoice later on. It goes through the
      # following steps:
      #
      #   1. Checks to see if there is a stored Xero contact id reference for the
      #      current Account and tries to find a valid contact in Xero with that id.
      #
      #   2. otherwise tries to find a Xero contact with the same name as the
      #      company and save that contact's id if a match was found.
      #
      #   3. otherwise tries to create a new Xero contact with the name of the
      #      company and save that contact's id
      #
      def handle_contact(company)
        ActiveRecord::Base.transaction do
          if company.contact.present?
            if (xero_id = company.contact.xero_id_for_account(@account)).present?
              return true if @client.Contact.find(xero_id)
            end

            if (xero_contact = @client.Contact.first(where: { name: company.contact.name })).present?
              company.contact.set_xero_id_for_account(@account, xero_contact.id)
              company.contact.save!

            else
              xero_contact = @client.Contact.build(name: company.contact.name)
              if xero_contact.save
                company.contact.set_xero_id_for_account(@account, xero_contact.id)
                company.contact.save!
              end
            end
          end
        end
      rescue ActiveRecord::ActiveRecordError => e
        add_error e
      end


      # === handle_plan
      #
      # This method retrieves an existing or new Invoice and then associates
      # all the non-allocated Billables for the current month, to this invoice.
      #
      def handle_plan(plan)
        ActiveRecord::Base.transaction do
          if (invoice = find_or_create_monthly_invoice(plan)).present?
            add_billables_to_invoice invoice
          end
        end
      rescue ActiveRecord::ActiveRecordError => e
        add_error e
      end


      # === handle_no_plan
      #
      # This method handles an invoice for billables when there is no plan
      # present for the company.
      #
      def handle_no_plan(company)
        ActiveRecord::Base.transaction do
          if (invoice = find_or_create_invoice(company)).present?
            add_billables_to_invoice invoice
          end
        end
      rescue ActiveRecord::ActiveRecordError => e
        add_error e
      end


      # === find_or_create_monthly_invoice
      #
      # This method creates an invoice based on a plan.
      #
      def find_or_create_monthly_invoice(plan)
        if (invoice = @account.invoices.invoices.managed.find_by(company_id: plan.company_id, invoice_for_month: invoice_for_month)).present?
          invoice

        else
          xero_invoice = create_xero_invoice(plan.company, plan)

          sync_invoices = ::Refinery::Business::Xero::Sync::Invoices.new @account, errors
          sync_invoices.sync! xero_invoice, is_managed: true, invoice_for_month: invoice_for_month
        end
      end


      # === find_or_create_invoice
      #
      # This method creates an invoice when there are billables but
      # no plan to act as the base for the invoice.
      #
      def find_or_create_invoice(company)
        if (invoice = @account.invoices.invoices.managed.find_by(company_id: company.id, invoice_for_month: invoice_for_month)).present?
          invoice

        else
          xero_invoice = create_xero_invoice(company)

          sync_invoices = ::Refinery::Business::Xero::Sync::Invoices.new @account, errors
          sync_invoices.sync! xero_invoice, is_managed: true, invoice_for_month: invoice_for_month
        end
      end


      # === create_xero_invoice
      #
      # This method creates a Xero Invoice based on a monthly plan,
      # but only if the company has a xero id matching the current
      # account.
      #
      def create_xero_invoice(company, plan = nil)
        if (xero_contact_id = company.contact&.xero_id_for_account(@account)).present?
          invoice_date = invoice_for_month.end_of_month

          currency_code = plan ? plan.currency_code : ::Refinery::Business::Invoice::DEFAULT_CURRENCY
          payment_terms = plan ? plan.payment_terms : ::Refinery::Business::Plan::PaymentTerms.default

          # Build Invoice based on Plan
          xero_invoice = @client.Invoice.build(
              type: 'ACCREC',
              status: 'DRAFT',
              currency_code: currency_code,
              currency_rate: ::Refinery::Business::Invoice::CURRENCY_RATES[currency_code],
              date: invoice_date,
              due_date: payment_terms.due_date_for(invoice_date),
          )

          # Set contact
          xero_invoice.build_contact(contact_id: xero_contact_id)

          # Xero requires at least on line item
          xero_invoice.add_line_item description: '-- -- --'

          if xero_invoice.save
            xero_invoice
          end
        end
      end

      def add_billables_to_invoice(invoice)
        invoice.company.billables.where(
            invoice_id: nil,
            billable_date: invoice_for_month..invoice_for_month.end_of_month
        ).each do |billable|
          billable.invoice = invoice
          billable.save!
        end
      end

      def add_error(e)
        @errors ||= []
        @errors << e
      end

      def errors
        @errors ||= []
      end

      def notify_finance_team
        begin
          @account.invoices.invoices.managed.where(invoice_for_month: invoice_for_month).each do |invoice|
            invoice.notify :'refinery/authentication/devise/users',
                            key: 'invoice.prepared'
          end

          # Send batch notification email to the users with unopened notifications of specified key in 1 hour
          Refinery::Authentication::Devise::User.send_batch_unopened_notification_email(
              batch_key: 'batch.invoice.prepared',
              filtered_by_key: 'invoice.prepared',
              custom_filter: ["created_at >= ?", 1.hour.ago]
          )

        rescue StandardError => e
          ErrorMailer.error_email(e).deliver
        end
      end

    end
  end
end
