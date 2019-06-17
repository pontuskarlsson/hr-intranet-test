namespace :hr_intranet do
  namespace :xero do

    API_KEY_ORGANISATION = 'Happy Rabbit Trading Limited'

    task sync_updated_invoices: [:set_logger, :environment] do
      begin
        Refinery::Business::Account.find_each do |account|
          xero_client = Refinery::Business::Xero::Client.new(account)
          syncer = Refinery::Business::Xero::Syncer.new account


          params = { order: 'UpdatedDateUTC' }
          if (latest_modified_at = account.invoices.maximum(:updated_date_utc)).present?
            Rails.logger.info "Last modified invoice in #{account.organisation} at #{latest_modified_at}"
            params[:modified_since] = latest_modified_at
          else
            Rails.logger.info 'No previous Invoice found'
          end

          # Load all Invoices that have been updated since last registered Invoice was updated
          invoices = xero_client.client.Invoice.all(params)
          Rails.logger.info "Found #{invoices.length} Invoices in Xero"

          # Load the unique Contacts used in those invoices
          contacts = invoices.each_with_object({}) { |invoice, acc|
            acc[invoice.attributes[:contact].contact_id] ||= invoice.contact
          }.values

          # Sync Contacts first
          syncer.sync_contacts contacts

          # Sync Invoices
          syncer.sync_invoices invoices
        end

      rescue StandardError => e
        ErrorMailer.new(e).deliver
        Rails.logger.error e.message
      end
    end

    task sync_all_invoices: [:set_logger, :environment] do
      begin
        Refinery::Business::Account.find_each do |account|
          xero_client = Refinery::Business::Xero::Client.new(account)
          syncer = Refinery::Business::Xero::Syncer.new account

          # Sync Contacts first so that we can cross-reference the contact ids later when syncing Invoices
          contacts = xero_client.client.Contact.all(where: { account_number_is_not: nil })
          Rails.logger.info "Found #{contacts.length} Contacts with account numbers in Xero"
          syncer.sync_contacts contacts

          # Sync Invoices
          invoices = xero_client.client.Invoice.all({ order: 'UpdatedDateUTC' })
          Rails.logger.info "Found #{invoices.length} Invoices in Xero"
          syncer.sync_invoices invoices

          if syncer.errors.any?
            ErrorMailer.new(syncer.errors.first, syncer.errors[1..-1]).deliver
          end
        end

      rescue StandardError => e
        ErrorMailer.new(e).deliver
        Rails.logger.error e.message
      end
    end

    task set_logger: :environment do
      if Rails.env.development?
        Rails.logger = Logger.new(STDOUT)
      end
    end

  end
end
