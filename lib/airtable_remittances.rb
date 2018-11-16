class AirtableRemittances

  # Class Constants
  #
  # === Examples
  #
  #   STATUS = %w(enabled disabled)
  #   TYPES = { 0 => :home, 1 => :away }.freeze
  #
  AT_INVOICE_SHEET = 'HR Invoices & CN'
  AT_BILL_SHEET = 'Bills & CN'
  AT_CONTACT_SHEET = 'Contacts'

  INV_COL_MAP = {
      invoice_id: ['InvoiceID', :string],
      invoice_number: ['Invoice Number', :string],
      date: ['Date', :date],
      due_date: ['Due Date', :date],
      status: ['Status', :string],
      total: ['Total Amount', :decimal],
      currency_code: ['Currency Code', :string],
      amount_due: ['Amount Due', :decimal],
      amount_paid: ['Amount Paid', :decimal],
      amount_credited: ['Amount Credited', :decimal],
      currency_rate: ['Currency Rate', :decimal],
      reference: ['Reference', :string],
      updated_date_utc: ['Updated At', :datetime],
      type: ['Type', :string]
  }

  def initialize(airtable_app_id)
    @airtable_app_id = airtable_app_id
  end

  # Public Methods
  #
  # === Examples
  #

  def latest_modified_at
    [
        airtable(AT_INVOICE_SHEET).records(sort: [INV_COL_MAP[:updated_date_utc][0], :desc], limit: 1).first,
        airtable(AT_BILL_SHEET).records(sort: [INV_COL_MAP[:updated_date_utc][0], :desc], limit: 1).first
    ].reject(&:nil?).map { |record| record[INV_COL_MAP[:updated_date_utc][0]] }.max
  end

  def sync_invoices(xero_invoices)
    xero_invoices.each do |xero_invoice|
      at_contact = update_or_create_record(AT_CONTACT_SHEET, 'ContactID', xero_invoice.contact.contact_id, address_for(xero_invoice.contact))

      invoice_attributes = INV_COL_MAP.each_pair.inject({ 'Contact' => [at_contact.id] }) do |acc, (xero_attr, at_col)|
        acc.merge(at_col[0] => parse_value(xero_invoice[xero_attr], at_col[1]))
      end

      sheet = xero_invoice.type == 'ACCREC' ? AT_INVOICE_SHEET : AT_BILL_SHEET
      update_or_create_record(sheet, 'InvoiceID', xero_invoice.invoice_id, invoice_attributes)
    end
  end


  private
  # Private Methods
  #
  # === Examples
  #

  def airtable(sheet)
    @airtables ||= {}
    @airtables[sheet] ||= Airtable::Client.new(ENV['AIRTABLE_KEY']).table(@airtable_app_id, sheet)
  end

  def update_or_create_record(sheet, column, value, attributes = {})
    # Building a cache
    @record_cache ||= {}
    @record_cache[sheet] ||= {}
    cache = @record_cache[sheet][column] ||= {}

    # Returning the record if we have already accessed it
    return cache[value] if cache[value].present?

    # Trying to find a record based on a value for the given column
    if (record = airtable(sheet).select(formula: "{#{column}} = \"#{value}\"").first).present?

      Rails.logger.info "Found #{sheet} for #{column} = #{value}."

      # If a record was found, then we check if any attribute have been changed
      changes = attributes.each_pair.inject({}) { |acc, (k,v)|
        if record[k] != v
          record[k] = v # Assign the value so that it is correct in the cached record for next retrieval
          acc.merge(k => v)
        else
          acc
        end
      }

      # Update the changed fields if any changes were detected
      if changes.any?
        Rails.logger.info "Updating #{sheet} with following changes: #{changes.inspect}."
        airtable(sheet).update_record_fields(record.id, changes)
      else
        Rails.logger.info "No update necessary."
      end

    else
      # Create a new record with all the attributes specified
      Rails.logger.info "Creating #{sheet} with following attributes: #{attributes.inspect}."
      record = Airtable::Record.new(attributes.merge(column => value))
      airtable(sheet).create(record)
    end

    # Assign record to cache and return it
    cache[value] = record
  end

  def address_for(contact)
    address = contact.addresses.detect { |a| a.type == 'STREET' }
    {
        'Name' => contact.name,
        'Address Line 1' => address.address_line1,
        'Address Line 2' => address.address_line2,
        'City' => address.city,
        'Region' => address.region,
        'Postal Code' => address.postal_code,
        'Country' => address.country
    }
  rescue StandardError => e
    {}
  end

  def parse_value(value, type)
    case type
      when :string
        value.to_s

      when :decimal
        if value.present?
          value.to_f
        end

      when :date
        if value.is_a?(Date)
          value.iso8601
        end

      when :datetime
        if value.is_a?(DateTime) || value.is_a?(Time)
          value.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')
        end
    end
  end

end
