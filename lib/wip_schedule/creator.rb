module WipSchedule
  class Creator

    attr_reader :airtable, :app_id, :excel, :filter, :last_error

    def initialize(airtable_app_id, filter)
      @app_id = airtable_app_id
      @airtable = WipSchedule::Airtable.new(airtable_app_id)
      @excel = WipSchedule::Excel.blank
      @filter = filter
      @tempfile = Tempfile.new
    end

    def create_wip_file
      airtable.orders_for(filter).each do |order|
        excel.add_row order
      end

      excel.finalize!(app_id, filter)

      excel.write(@tempfile)
      true

    rescue WipSchedule::Airtable::AirtableError => e
      @last_error = e
      false
    end

    def wip_file_path
      @tempfile.path
    end

  end
end
