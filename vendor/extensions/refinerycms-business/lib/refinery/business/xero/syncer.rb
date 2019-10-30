module Refinery
  module Business
    module Xero
      class Syncer

        attr_reader :account, :errors

        def initialize(account)
          @account = account
          @account_company = nil #Refinery::Business::Company.find_by! name: account.organisation
          @errors = []
        end

        def sync_changes!
          params = { order: 'UpdatedDateUTC', modified_since: account.articles.maximum(:updated_date_utc) }.compact

          items = client.Item.all(params)
          Rails.logger.info "Found #{items.length} Items in Xero"

          # Sync Articles/Items
          sync_items items

          params = { order: 'UpdatedDateUTC', modified_since: account.invoices.maximum(:updated_date_utc) }.compact

          invoices = client.Invoice.all(params)
          Rails.logger.info "Found #{invoices.length} Invoices in Xero"

          # When syncing updated invoices only, we only load Contact details if there is no previous
          # record of the contact. Any changes in contact details from Xero will be handled during
          # full sync.
          contacts = invoices.each_with_object({}) { |invoice, acc|
            unless ::Refinery::Marketing::Contact.find_by_xero_id(account, invoice.attributes[:contact].contact_id).present?
              acc[invoice.attributes[:contact].contact_id] ||= invoice.contact
            end
          }.values

          # Sync Contacts first
          sync_contacts contacts

          # Sync Invoices
          sync_invoices invoices
        end

        def sync_all!
          # Sync Contacts first so that we can cross-reference the contact ids later when syncing Invoices
          contacts = client.Contact.all(where: { account_number_is_not: nil })
          sync_contacts contacts

          # Sync Items
          items = client.Item.all({ order: 'UpdatedDateUTC' })
          sync_items items

          # Sync Invoices
          invoices = client.Invoice.all({ order: 'UpdatedDateUTC' })
          sync_invoices invoices
        end

        def sync_invoices(xero_invoices)
          sync_invoices = ::Refinery::Business::Xero::Sync::Invoices.new account, errors

          xero_invoices.each do |xero_invoice|
            sync_invoices.sync! xero_invoice
          end
        end

        def sync_contacts(xero_contacts)
          sync_contacts = ::Refinery::Business::Xero::Sync::Contacts.new account, errors

          xero_contacts.each do |xero_contact|
            sync_contacts.sync! xero_contact
          end
        end

        def sync_items(xero_items)
          sync_items = ::Refinery::Business::Xero::Sync::Items.new account, errors

          items.each do |xero_item|
            sync_items.sync! xero_item
          end; ''
        end

        private

        def client
          @xero_client ||= ::Refinery::Business::Xero::Client.new(account)
          @xero_client.client
        end

      end
    end
  end
end
