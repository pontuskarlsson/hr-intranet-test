module Portal
  module Stripe
    class WebhookJob < Struct.new(:type, :data)

      # def enqueue(job)
      #
      # end

      def perform
        case type
        when 'checkout.session.completed' then perform_checkout_session
        when 'payout.paid' then perform_payout
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
          purchase.webhook_object = object.to_hash
          purchase.stripe_payment_intent_id = purchase.webhook_object['payment_intent']

          payment_intent = Stripe::PaymentIntent.retrieve purchase.stripe_payment_intent_id

          purchase.card_object = payment_intent.charges.first.payment_method_details.card.to_hash
          purchase.stripe_charge_id = payment_intent.charges.first.id
          purchase.save!

          process_invoice!(purchase)
        end
      end

      def process_invoice!(purchase)
        handle_contact purchase.company
        xero_invoice = create_xero_invoice(purchase)

        sync_invoices = ::Refinery::Business::Xero::Sync::Invoices.new account, errors
        purchase.invoice = sync_invoices.sync! xero_invoice, is_managed: true
        purchase.invoice.invoice_number = purchase.invoice.invoice_number.gsub('INV', 'REC')
        purchase.invoice.save!

        purchase.invoice.update_stripe_ref! 'StripePI', purchase.stripe_payment_intent_id
        purchase.invoice.update_stripe_ref! 'StripeCH', purchase.stripe_charge_id

        purchase.save!

        form = Refinery::Business::PurchaseInvoiceBuildForm.new_in_model(purchase.invoice)
        form.save!
      rescue StandardError => exception
        ErrorMailer.error_email(exception).deliver
      end

      def account
        @account ||= Refinery::Business::Account.find_by!(organisation: 'Happy Rabbit Limited')
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
              reference: purchase.stripe_payment_intent_id, # "Receipt for Prepayment (#{purchase.created_at.strftime("%Y-%m-%d")})"
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

      def perform_payout
        ActiveRecord::Base.transaction do
          object = data['object']

          payout_id = object['id']
          list = Stripe::BalanceTransaction.list(payout: payout_id, type: 'charge')
          process_transactions payout_id, list

          # Send batch notification email to the users with unopened notifications of specified key in 1 hour
          Refinery::Authentication::Devise::User.send_batch_unopened_notification_email(
              batch_key: 'batch.invoice.payout',
              filtered_by_key: 'invoice.payout',
              custom_filter: ["created_at >= ?", 5.minutes.ago]
          )
        end
      end

      def process_transactions(payout_id, list)
        list.each do |balance_transaction|
          if (purchase = ::Refinery::Business::Purchase.find_by(stripe_charge_id: balance_transaction.source)).present?
            purchase.stripe_payout_id = payout_id
            purchase.save!

            if purchase.invoice.present?
              purchase.invoice.reference = payout_id
              purchase.invoice.update_stripe_ref! 'StripePO', purchase.stripe_payout_id
              push_invoice_to_xero purchase.invoice

              purchase.invoice.notify :'refinery/authentication/devise/users', key: 'invoice.payout'
            end
          end
        end

        process_transactions payout_id, list.next_page if list.has_more
      end

      def push_invoice_to_xero(invoice)
        account = invoice.account
        xero_authorization = account.omni_authorizations.xero.first

        syncer = Refinery::Business::Xero::Syncer.new account, xero_authorization

        syncer.push_invoice invoice
      end

    end
  end
end
