module Refinery
  module Business
    module Xero
      module Sync
        class Invoices

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

          attr_reader :account, :errors

          def initialize(account, errors)
            @account = account
            @errors = errors
          end

          def sync!(xero_invoice)
            invoice = account.invoices.find_or_initialize_by(invoice_id: xero_invoice.invoice_id)

            # Calling the getter +contact+ will make another API call to load additional
            # contact data, but using attributes[:contact] will not do that.
            #
            invoice.contact_id = xero_invoice.attributes[:contact].contact_id

            if (contact = ::Refinery::Marketing::Contact.find_by_xero_id(account, invoice.contact_id)).present? && contact.company.present?
              invoice.company = contact.company
            end

            invoice.attributes = SYNC_ATTRIBUTES.each_with_object({}) { |(local, remote), acc|
              acc[local] = xero_invoice.attributes[remote]
            }

            if invoice.invoice_type == 'ACCREC'
              invoice.from_company = @account_company
              invoice.to_company = invoice.company
              invoice.to_contact_id = invoice.contact_id
            else
              invoice.to_company = @account_company
              invoice.from_company = invoice.company
              invoice.from_contact_id = invoice.contact_id
            end

            invoice.save!
          rescue ::ActiveRecord::RecordNotSaved => e
            errors << e
          end

        end
      end
    end
  end
end
