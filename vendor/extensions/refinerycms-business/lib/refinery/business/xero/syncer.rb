module Refinery
  module Business
    module Xero
      class Syncer

        attr_reader :account, :errors

        def initialize(account, xero_authorization)
          @account = account
          @xero_authorization = xero_authorization
          @authentication = xero_authorization.omni_authentication
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

          xero_items.each do |xero_item|
            sync_items.sync! xero_item
          end
        end

        def push_invoice(invoice)
          push_invoices = ::Refinery::Business::Xero::Push::Invoices.new client, errors

          if invoice.invoice_id.present?
            xero_invoice = client.Invoice.find(invoice.invoice_id)
            sync_invoices.update!(invoice, xero_invoice)
          else

          end

        end

        #private

        def client
          @xero_client ||= ::Refinery::Business::Xero::Client.new(access_token, @xero_authorization.tenant_id)
          @xero_client.client
        end

        def access_token
          @access_token ||=
              if @authentication.token_expired?(1.minute)
                refresh_token
              else
                @authentication.token
              end
        end

        def refresh_token
          system_time = Time.now.to_i
          xero_token_endpoint = 'https://identity.xero.com/connect/token'
          refresh_request_body_hash = {
              grant_type: 'refresh_token',
              refresh_token: @authentication.refresh_token
          }

          resp = Faraday.post(xero_token_endpoint) do |req|
            req.headers['Authorization'] = basic_auth
            req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
            req.body = URI.encode_www_form(refresh_request_body_hash)
          end

          if resp.status == 200
            resp_hash = JSON.parse(resp.body)

            @authentication.token = resp_hash['access_token']
            @authentication.refresh_token = resp_hash['refresh_token']
            @authentication.token_expires = system_time + resp_hash['expires_in']
            @authentication.save
          else
            raise 'Failed to refresh access token'
          end
          @authentication.token
        end

        def basic_auth
          'Basic ' + Base64.strict_encode64(ENV['XERO_CLIENT_ID'] + ':' + ENV['XERO_CLIENT_SECRET'])
        end

      end
    end
  end
end
