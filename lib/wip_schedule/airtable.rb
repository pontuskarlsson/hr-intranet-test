module WipSchedule
  class Airtable

    AT_ORDER_SHEET = 'Requests / Orders'
    AT_WIP_VIEW = 'WIP'

    STATUS_CANCELLED = 'CANCELLED'
    STATUS_DRAFT = 'DRAFT'

    def initialize(app_id)
      @app_id = app_id
    end

    def orders_for(filter = nil)
      order_table.all(:sort => ["Customer PO#", :asc], view: AT_WIP_VIEW).select do |order|
        ![STATUS_CANCELLED, STATUS_DRAFT].include?(order['Order Status']) && (filter.blank? || order['Supplier'][0] == filter)
      end

    rescue StandardError => e
      raise AirtableError.new(e.message)
    end

    def update_record_fields(id, changed_fields)
      order_table.update_record_fields(id, changed_fields)
    end

    def order_table
      @airtable ||= ::Airtable::Client.new(ENV['AIRTABLE_KEY']).table(@app_id, AT_ORDER_SHEET)
    end

    class AirtableError < StandardError
    end
  end
end
