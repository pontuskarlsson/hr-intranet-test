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
          end
        end

        def sync_invoice(xero_invoice)
          invoice = account.invoices.find_or_initialize_by(invoice_id: xero_invoice.invoice_id)

          # Calling the getter +contact+ will make another API call to load additional
          # contact data, but using attributes[:contact] will not do that.
          #
          invoice.contact_id = xero_invoice.attributes[:contact].contact_id

          if (contact = find_contact_by_xero_id(invoice.contact_id)).present? && contact.company.present?
            invoice.company = contact.company
          end

          invoice.attributes = SYNC_ATTRIBUTES.each_with_object({}) { |(local, remote), acc|
            acc[local] = xero_invoice.attributes[remote]
          }

          # Try to match and associate with Project, but only if it is not already
          # associated, because we don't want to automatically override a manually
          # assigned project.
          #
          # The Project reference can currently be found either in Invoice Number or
          # Reference.
          if invoice.project_id.nil?
            if (res = /Project ([0-9]{5})/.match(invoice.reference)).present?
              invoice.project = ::Refinery::Business::Project.find_by code: res[1]
            elsif (res = /Project ([0-9]{5})/.match(invoice.invoice_number)).present?
              invoice.project = ::Refinery::Business::Project.find_by code: res[1]
            end
          end

          invoice.save!
        end

        def sync_contacts(xero_contacts)
          xero_contacts.each do |xero_contact|
            sync_contact xero_contact
          end
        end

        def sync_contact(xero_contact)
          if xero_contact.account_number.present?
            code = xero_contact.account_number.rjust(5, '0')
            company = Refinery::Business::Company.find_by(code: code)

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

        def find_contact_by_xero_id(xero_id)
          if account.organisation == 'Happy Rabbit Limited'
            Refinery::Marketing::Contact.where(xero_hr_id: xero_id).first

          elsif account.organisation == 'Happy Rabbit Trading Limited'
            Refinery::Marketing::Contact.where(xero_hrt_id: xero_id).first
          end
        end

      end
    end
  end
end
