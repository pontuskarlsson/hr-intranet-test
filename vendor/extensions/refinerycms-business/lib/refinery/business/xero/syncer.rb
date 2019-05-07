module Refinery
  module Business
    module Xero
      class Syncer

        SYNC_ATTRIBUTES = {
            invoice_number: :invoice_number,
            invoice_type: :type,
            reference: :reference,
            invoice_date: :date,
            due_date: :due_date,
            status: :status,
            total_amount: :total,
            amount_due: :amount_due,
            amount_paid: :amount_paid,
            amount_credited: :amount_credited,
            currency_code: :currency_code,
            currency_rate: :currency_rate,
            updated_date_utc: :updated_date_utc,
        }.freeze

        attr_reader :account

        def initialize(account)
          @account = account
        end

        def sync_invoices(xero_invoices)
          xero_invoices.each do |xero_invoice|
            sync_invoice xero_invoice

            # Calling the getter +contact+ will make another API call to load additional
            # contact data, but using attributes[:contact] will not do that.
            #
            sync_contact xero_invoice.attributes[:contact]
          end
        end

        def sync_invoice(xero_invoice)
          invoice = account.invoices.find_or_initialize_by(invoice_id: xero_invoice.invoice_id)

          invoice.contact_id = xero_invoice.attributes[:contact].contact_id

          invoice.attributes = SYNC_ATTRIBUTES.each_with_object({}) { |(local, remote), acc|
            acc[local] = xero_invoice.attributes[remote]
          }

          invoice.save!
        end

        def sync_contact(xero_contact)
          if xero_contact.account_number.present?
            code = xero_contact.account_number.rjust(5, '0')
            company = Refinery::Business::Company.where(code: code).first

            if company && company.contact
              assign_xero_id company.contact, xero_contact.contact_id
            end
          end
        end

        def assign_xero_id(contact, xero_id)
          if account.organisation == 'Happy Rabbit Limited'
            contact.update_attributes xero_hr_id: xero_id

          elsif account.organisation == 'Happy Rabbit Trading Limited'
            contact.update_attributes xero_hrt_id: xero_id
          end
        end

      end
    end
  end
end
