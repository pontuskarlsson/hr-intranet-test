module Portal
  module Stripe
    class WebhookJob < Struct.new(:type, :data)

      # def enqueue(job)
      #
      # end

      def perform
        case type
        when 'checkout.session.completed' then perform_checkout_session
        else raise 'Unknown object'
        end
      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        ErrorMailer.notification_email(["Portal::Stripe::WebhookJob #{job.id} has succeeded."]).deliver
      end

      def error(job, exception)
        ErrorMailer.error_email(exception).deliver
      end

      def failure(job)
        ErrorMailer.notification_email(["Portal::Stripe::WebhookJob #{job.id} has failed after trying too many times unsuccessfully.", job.inspect]).deliver
      end

      private

      def perform_checkout_session
        ActiveRecord::Base.transaction do
          object = data['object']
          purchase = ::Refinery::Business::Purchase.find_by_happy_rabbit_reference_id! object['client_reference_id']
          purchase.status = 'paid'
          purchase.webhook_object = object
          purchase.save!

          process_invoice!(purchase)

          # base_amount = purchase.sub_total_cost / purchase.qty.to_i
          # discount_amount = purchase.total_discount / purchase.qty.to_i
          #
          # vouchers = purchase.no_of_credits.times.map do
          #   purchase.company.vouchers.create!(
          #       article: purchase.article,
          #       status: 'active',
          #       source: 'purchase',
          #       discount_type: 'fixed_amount',
          #       base_amount: base_amount,
          #       discount_amount: discount_amount,
          #       amount: base_amount + discount_amount,
          #       currency_code: 'usd',
          #       valid_from: purchase.created_at.to_date,
          #       valid_to: purchase.created_at.to_date + 1.year - 1.day
          #   )
          # end
        end
      end

      def process_invoice!(purchase)
        handle_contact purchase.company
        xero_invoice = create_xero_invoice(purchase)

        sync_invoices = ::Refinery::Business::Xero::Sync::Invoices.new account, errors
        invoice = sync_invoices.sync! xero_invoice, is_managed: true

        form = Refinery::Business::PurchaseInvoiceBuildForm.new_in_model(invoice)
        form.save!
      rescue StandardError => exception
        ErrorMailer.error_email(exception).deliver
      end

      def account
        @account ||= Refinery::Business::Account.find_by!(name: 'Happy Rabbit Limited')
      end

      def client
        @client ||= ::Refinery::Business::Xero::Client.new(@account.omni_authorizations.xero.first!).client
      end

      # === create_xero_invoice
      #
      # This method creates a Xero Invoice based on a monthly plan,
      # but only if the company has a xero id matching the current
      # account.
      #
      def create_xero_invoice(purchase)
        if (xero_contact_id = purchase.company.contact&.xero_id_for_account(account)).present?
          currency_code = ::Refinery::Business::Invoice::DEFAULT_CURRENCY

          # Build Invoice based on Plan
          xero_invoice = client.Invoice.build(
              type: 'ACCREC',
              status: 'DRAFT',
              currency_code: currency_code,
              currency_rate: ::Refinery::Business::Invoice::CURRENCY_RATES[currency_code],
              date: purchase.created_at,
              due_date: purchase.created_at,
              reference: "Invoice for Prepayment (#{purchase.created_at.strftime("%Y-%m-%d")})"
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
            if (xero_id = company.contact.xero_id_for_account(account)).present?
              return true if client.Contact.find(xero_id)
            end

            if (xero_contact = client.Contact.first(where: { name: company.contact.name })).present?
              company.contact.set_xero_id_for_account(account, xero_contact.id)
              company.contact.save!

            else
              xero_contact = client.Contact.build(name: company.contact.name)
              if xero_contact.save
                company.contact.set_xero_id_for_account(account, xero_contact.id)
                company.contact.save!
              end
            end
          end
        end
      rescue ActiveRecord::ActiveRecordError => e
        add_error e
      end

      def add_error(e)
        @errors ||= []
        @errors << e
      end

      def errors
        @errors ||= []
      end

    end
  end
end
