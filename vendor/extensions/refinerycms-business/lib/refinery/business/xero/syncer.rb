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

        def initialize(account)
          @account = account
        end

        def sync_invoices(xero_invoices)
          xero_invoices.each do |xero_invoice|
            invoice = account.invoices.find_or_initialize_by(invoice_id: xero_invoice.invoice_id)
            invoice.contact_id = xero_invoice.contact.contact_id
            invoice.attributes = SYNC_ATTRIBUTES.each_with_object({}) { |(to, from), acc|
              acc[to] = xero_invoice.attributes[from]
            }
            invoice.save!
          end
        end

      end
    end
  end
end
