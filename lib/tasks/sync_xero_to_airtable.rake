namespace :hr_intranet do
  namespace :xero do

    API_KEY_ORGANISATION = 'Happy Rabbit Trading Limited'

    task sync_updated_invoices: [:set_logger, :environment] do
      begin
        Refinery::Business::Account.find_each do |account|
          xero_client = Refinery::Business::Xero::Client.new(account)
          params = { order: 'UpdatedDateUTC' }

          if (latest_modified_at = account.invoices.maximum(:updated_date_utc)).present?
            Rails.logger.info "Last modified invoice in #{account.organisation} at #{latest_modified_at}"
            params[:modified_since] = latest_modified_at
          else
            Rails.logger.info 'No previous Invoice found'
          end

          invoices = xero_client.client.Invoice.all(params)
          Rails.logger.info "Found #{invoices.length} Invoices in Xero"

          syncer = Refinery::Business::Xero::Syncer.new account
          syncer.sync_invoices invoices
        end

      rescue StandardError => e
        Rails.logger.error e.message
      end
    end

    task sync_all_invoices: [:set_logger, :environment] do
      begin
        Refinery::Business::Account.find_each do |account|
          xero_client = Refinery::Business::Xero::Client.new(account)
          params = { order: 'UpdatedDateUTC' }

          invoices = xero_client.client.Invoice.all(params)
          Rails.logger.info "Found #{invoices.length} Invoices in Xero"

          syncer = Refinery::Business::Xero::Syncer.new account
          syncer.sync_invoices invoices
        end

      rescue StandardError => e
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
