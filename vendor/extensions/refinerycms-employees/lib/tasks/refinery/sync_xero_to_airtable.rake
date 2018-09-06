namespace :hr_intranet do
  namespace :xero do

    API_KEY_ORGANISATION = 'Happy Rabbit Trading Limited'
    AT_APP_ID = ENV['AIRTABLE_REMITTANCES_APP']

    task sync_updated_invoices: [:set_logger, :environment] do
      begin
        xero_client = Refinery::Employees::XeroClient.new(API_KEY_ORGANISATION)
        airtable_remittances = AirtableRemittances.new(AT_APP_ID)
        params = { order: 'UpdatedDateUTC' }

        if (latest_modified_at = airtable_remittances.latest_modified_at).present?
          Rails.logger.info "Last modified invoice in Airtable at #{latest_modified_at}"
          params[:modified_since] = DateTime.parse(latest_modified_at)
        else
          Rails.logger.info 'No previous Invoice found in Airtable'
        end

        invoices = xero_client.client.Invoice.all(params)
        Rails.logger.info "Found #{invoices.length} Invoices in Xero"

        airtable_remittances.sync_invoices invoices

      rescue StandardError => e
        Rails.logger.error e.message
      end
    end

    task sync_all_invoices: [:set_logger, :environment] do
      begin
        xero_client = Refinery::Employees::XeroClient.new(API_KEY_ORGANISATION)
        airtable_remittances = AirtableRemittances.new(AT_APP_ID)
        params = { order: 'UpdatedDateUTC' }

        invoices = xero_client.client.Invoice.all(params)
        Rails.logger.info "Found #{invoices.length} Invoices in Xero"

        airtable_remittances.sync_invoices invoices

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
