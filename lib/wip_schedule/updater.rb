module WipSchedule
  class Updater

    attr_reader :airtable_app_id, :filter

    def initialize(file)
      @excel = WipSchedule::Excel.new Spreadsheet.open(file.path)
      @airtable_app_id = @excel.get_app_id
      @filter = @excel.get_filter
      @custom_list = WipSchedule::CustomList.new
      @results = { orders: {}, description: nil }

      raise 'Could not detect any +airtable_app_id+ in the order worksheet.' if airtable_app_id.blank?
    end

    def update_wip_orders
      # Makes sure the airtable app id does exist in our custom list
      list_row = @custom_list.list_row_for(airtable_app_id, filter)
      raise "Could not find any matching row for app id: #{airtable_app_id} with filter: #{filter}." if list_row.blank?

      # Retrieve orders from Airtable
      row_data = @custom_list.data_for(list_row)
      @results[:description] = row_data['Description']
      @results[:recipients] = row_data['Recipients']

      each_airtable_order do |id, at_order, excel_order|
        changed_fields = changes_from(at_order, excel_order)

        if changed_fields.any?
          if changed_fields['Comments']
            changed_fields['Comments At'] = Date.today.to_s
          end
          begin
            wip_airtable.update_record_fields(id, changed_fields)
          rescue StandardError => e
            @results[:orders][id][:error] = "Failed to update, Reason: #{e.message}"
          end
        end
      end

      # If we got all the way here, we assume it was okay and flag that we received an update today
      @custom_list.set_last_updated_at!(list_row, Date.today)

      @results
    end

    def wip_airtable
      @wip_airtable ||= WipSchedule::Airtable.new(airtable_app_id)
    end

    def each_airtable_order(&block)
      orders = wip_airtable.orders_for(filter)

      raise "Could not find any orders in the Airtable app #{airtable_app_id} for #{@results[:description]}." if orders.empty?

      orders.each do |order|
        title = [order['Customer PO#'], order['HR PO#']].reject(&:blank?).join ' / '
        @results[:orders][order.id] = {
            title: title,
            updates: {}
        }

        excel_row = @excel.find_row(order.id)

        if excel_row
          block.call order.id, order, excel_row
        else
          @results[:orders][order.id][:error] = 'Order not included in WIP Excel file.'
        end
      end
    end

    def changes_from(at_order, excel_order)
      order_id = at_order.id

      WipSchedule::Excel::ALLOW_UPDATES.each_with_object({}) do |col, changed_fields|
        begin
          column_value = value_from_excel excel_order, col

          # Need to also check that both values or not blank, because api returns empty string for number values when they should be nil
          if column_value != at_order[col] && !(column_value.blank? && at_order[col].blank?)
            if WipSchedule::Excel::ONLY_IF_BLANK.include?(col) && at_order[col].present?
              @results[:orders][order_id][:updates][col] = { error: "Tried to change #{col} from #{at_order[col].to_s} to #{changed_fields[col].to_s}. This is not allowed." }
            else
              changed_fields[col] = column_value
              @results[:orders][order_id][:updates][col] = { from: at_order[col].to_s, to: changed_fields[col].to_s }
            end
          end
        rescue StandardError => e
          @results[:orders][order_id][:updates][col] = { error: "Invalid value: #{excel_order[WipSchedule::Excel::COLUMNS.keys.index(col)]}" }
        end
      end
    end

    def value_from_excel(excel_order, col)
      value = excel_order[WipSchedule::Excel::COLUMNS.keys.index(col)]

      case WipSchedule::Excel::COLUMNS[col][:type]
        when :date
          value.present? ? value.to_date.to_s : ''
        when :number
          value.present? ? value.to_i : ''
        when :currency
          value.present? ? value.to_f : ''
        else
          value.to_s
      end
    end
  end
end
