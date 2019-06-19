module WipSchedule
  class Creator

    attr_reader :airtable, :app_id, :excel, :filter, :last_error
    delegate :attentions, to: :excel

    def initialize(row)
      @app_id, @filter, @description = row['Airtable App Id'], row['Filter'], row['Description']

      @airtable = WipSchedule::Airtable.new(@app_id)
      @excel = WipSchedule::Excel.blank
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
