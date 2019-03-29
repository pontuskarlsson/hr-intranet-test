module WipSchedule
  class CustomList

    CUSTOM_LIST_TITLE = 'WIP Schedule'

    attr_reader :list

    delegate :data, to: :list

    def initialize(title = CUSTOM_LIST_TITLE)
      @list = ::Refinery::CustomLists::CustomList.find_by_title!(title)
    rescue ::ActiveRecord::RecordNotFound
      raise NotFound.new("Could not find list #{title}")
    end

    def column(name)
      columns_index[name] || (raise NotFound.new("Could not find column #{name} in list #{list.title}"))
    end

    def each_open_row(&block)
      list.data.each do |row|
        if row['Status'] == 'Open'
          block.call row
        end
      end
    end

    def list_row_for(airtable_app_id, filter)
      list.list_rows.includes(:list_cells).detect { |lr|
        lr.list_cells.detect { |lc| lc.list_column_id == airtable_app_column.id && lc.value == airtable_app_id } &&
            lr.list_cells.detect { |lc| lc.list_column_id == filter_column.id && lc.value == filter.to_s }
      }
    end

    def data_for(list_row)
      list_row.data_for(list.list_columns)
    end

    def set_last_updated_at!(list_row, date)
      updated_at_cell = list_row.list_cells.find_by_list_column_id!(last_updated_at_column.id)
      updated_at_cell.update_attributes(value: date)
    end

    def airtable_app_column
      @airtable_app_column ||= list.list_columns.find_by_title!('Airtable App Id')
    end

    def filter_column
      @filter_column ||= list.list_columns.find_by_title!('Filter')
    end

    def last_updated_at_column
      @last_updated_at_column ||= list.list_columns.find_by_title!('Last Updated At')
    end

    def status_column
      @status_column ||= list.list_columns.find_by_title!('Status')
    end

    private

    def columns_index
      @columns_index ||= list.list_columns.index_by(&:title)
    end

    class NotFound < ::ActiveRecord::RecordNotFound
    end

  end
end
