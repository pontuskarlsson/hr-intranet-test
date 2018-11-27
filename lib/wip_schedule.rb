class WipSchedule

  CUSTOM_LIST_TITLE = 'WIP Schedule'

  COLUMNS = {
      "id" => { column: { hidden: true } },
      "Order Type" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Style No" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Style Name" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Description" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Theme" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Colour Name" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Order Date" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Qty" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Customer PO#" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "HR PO#" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Vendor PI#" => { column: { width: '15' } },
      "Ship To" => { column: { width: '10' }, format: { pattern_fg_color: :silver, pattern: 1 } },

      "Req. Ex. Fact. Date" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "1st Conf. Ex. Fact. Date" => { column: { width: '15' } },
      "Re-Negoti. Ex. Fact. Date" => { column: { width: '15' } },

      "Orig: Trims In-House" => { column: { width: '15' } },
      "Upd: Trims In-House" => { column: { width: '15' } },
      "Act: Trims In-House" => { column: { width: '15' } },

      "Orig: Fabric In-House" => { column: { width: '15' } },
      "Upd: Fabric In-House" => { column: { width: '15' } },
      "Act: Fabric In-House" => { column: { width: '15' } },

      "Orig: Cutting Complete" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Cutting Complete" => { column: { width: '15' } },
      "Act: Cutting Complete" => { column: { width: '15' } },

      "Orig: Sewing Complete" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Sewing Complete" => { column: { width: '15' } },
      "Act: Sewing Complete" => { column: { width: '15' } },

      "Orig: Final Inspection" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Final Inspection" => { column: { width: '15' } },
      "Act: Final Inspection" => { column: { width: '15' } },

      "Orig: Shipment Sample Sent" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Shipment Sample Sent" => { column: { width: '15' } },
      "Act: Shipment Sample Sent" => { column: { width: '15' } },

      "Orig: Ex. Fact." => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Ex. Fact." => { column: { width: '15' } },
      "Act: Ex. Fact." => { column: { width: '15' } },
      "Comments" => { column: { width: '30' } },
  }.freeze

  ALLOW_UPDATES = [
      "Vendor PI#",

      "1st Conf. Ex. Fact. Date",
      "Re-Negoti. Ex. Fact. Date",

      "Orig: Trims In-House",
      "Upd: Trims In-House",
      "Act: Trims In-House",

      "Orig: Fabric In-House",
      "Upd: Fabric In-House",
      "Act: Fabric In-House",

      "Upd: Cutting Complete",
      "Act: Cutting Complete",

      "Upd: Sewing Complete",
      "Act: Sewing Complete",

      "Upd: Final Inspection",
      "Act: Final Inspection",

      "Upd: Shipment Sample Sent",
      "Act: Shipment Sample Sent",

      "Upd: Ex. Fact.",
      "Act: Ex. Fact.",

      "Comments"
  ]

  ORDER_WORKSHEET = 'Orders'

  AT_ORDER_SHEET = 'Requests / Orders'
  AT_WIP_VIEW = 'WIP'

  def initialize()

  end

  def create_workbook_from(airtable_app_id, filter)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet name: ORDER_WORKSHEET

    # Add order data
    airtable_orders_for(airtable_app_id, filter).each_with_index do |order, order_i|
      COLUMNS.each_pair.each_with_index do |(column, options), column_i|
        if order[column].is_a? Array
          sheet1[order_i+1, column_i] = order[column].join(', ')
        else
          sheet1[order_i+1, column_i] = order[column]
        end

        if column == '1st Conf. Ex. Fact. Date'
          value = order[column]
          if value.blank?
            sheet1.row(order_i+1).set_format(column_i, Spreadsheet::Format.new((options[:format] || {}).merge(pattern_fg_color: :red, pattern: 1)))
          end

        elsif ["Orig: Trims In-House", "Orig: Fabric In-House"].include?(column)
          value = order[column]
          if value.blank?
            sheet1.row(order_i+1).set_format(column_i, Spreadsheet::Format.new((options[:format] || {}).merge(pattern_fg_color: :red, pattern: 1)))
          end


        elsif column[/^Upd: /]
          oper = column.gsub('Upd: ', '')
          orig_value = order["Orig: #{oper}"]
          act_value = order["Act: #{oper}"]
          value = order[column]

          if value.blank?
            if act_value.blank? && orig_value.present? && orig_value.to_date < Date.today
              sheet1.row(order_i+1).set_format(column_i, Spreadsheet::Format.new((options[:format] || {}).merge(pattern_fg_color: :red, pattern: 1)))
            end

          elsif act_value.blank? && value.to_date < Date.today
            sheet1.row(order_i+1).set_format(column_i, Spreadsheet::Format.new((options[:format] || {}).merge(color: :red)))
          end
        end
      end
    end

    # Set column settings last, otherwise they seem to be ignored
    COLUMNS.each_pair.each_with_index do |(column, options), column_i|
      sheet1[0, column_i] = column
      if options[:column]
        options[:column].each_pair do |k ,v|
          sheet1.column(column_i).send("#{k}=", v)
        end
      end
      if options[:format]
        sheet1.format_column column_i, Spreadsheet::Format.new(options[:format])
      end
    end

    sheet1[0,0] = [airtable_app_id, filter].reject(&:blank?).join(',')

    sheet1.freeze! 0, 7

    book
  end


  def update_wip_orders(params)
    @msgs = []

    filename = params[:file].tempfile.path
    book = Spreadsheet.open filename
    sheet = book.worksheet ORDER_WORKSHEET

    airtable_app_id, *filter = sheet[0,0].to_s.split(',')
    filter = filter.join(',')
    raise 'Could not detect any +airtable_app_id+ in the order worksheet.' if airtable_app_id.blank?

    # Makes sure the airtable app id does exist in our custom list
    list_row = custom_list.list_rows.includes(:list_cells).detect { |lr|
      lr.list_cells.detect { |lc| lc.list_column_id == airtable_app_column.id && lc.value == airtable_app_id } &&
          lr.list_cells.detect { |lc| lc.list_column_id == filter_column.id && lc.value == filter.to_s }
    }
    raise "Could not find any matching row for app id: #{airtable_app_id} with filter: #{filter}." if list_row.blank?

    # Retrieve orders from Airtable
    row_data = list_row.data_for(custom_list.list_columns)
    orders = airtable_orders_for(airtable_app_id, row_data['Filter'])
    raise "Could not find any orders in the Airtable app #{airtable_app_id} for #{row_data['Description']}." if orders.empty?

    # Scan order detail for any changes and update if necessary
    all_shipped = true
    orders.each do |order|
      if (excel_order = sheet.rows.detect { |row| row[0] == order['id'] }).present?
        changed_fields = {}
        ALLOW_UPDATES.each do |col|
          column_value = excel_order[COLUMNS.keys.index(col)].to_s
          if order[col].to_s != column_value
            begin
              # Will raise an error if the value is not a date (and column is not Comments)
              column_value.to_date if column_value.present? && col != 'Comments'

              #order[col] = column_value.blank? ? nil : column_value
              changed_fields[col] = column_value.blank? ? nil : column_value
            rescue StandardError => e
              @msgs << "The column \"#{col}\" has an invalid value: #{column_value}"
            end
          end
        end
        if changed_fields.any?
          if changed_fields['Comments']
            changed_fields['Comments At'] = Date.today.to_s
          end
          begin
            wip_airtable(airtable_app_id).update_record_fields(order.id, changed_fields)
            @msgs << "Order #{order["HR PO#"]} was updated with:\n- #{changed_fields.map { |k,v| "#{k}: #{v}" }.join("\n")}"
          rescue StandardError => e
            @msgs << "Failed to update the order #{order["HR PO#"]} with:\n- #{changed_fields.map { |k,v| "#{k}: #{v}" }.join("\n")}\nReason: #{e.message}"
          end
        end

        if excel_order[COLUMNS.keys.index("Act: Ex. Fact.")].blank?
          all_shipped = false
        end

      else
        all_shipped = false
        @msgs << "Could not find the order #{order["HR PO#"]} in the excel file."
      end
    end

    # If we got all the way here, we assume it was okay and flag that we received an update today
    updated_at_cell = list_row.list_cells.find_by_list_column_id!(last_updated_at_column.id)
    updated_at_cell.update_attributes(value: Date.today)

    if all_shipped
      description = row_data['Description']
      @msgs << "All orders have been shipped for #{description}."
      updated_at_cell = list_row.list_cells.find_by_list_column_id!(status_column.id)
      updated_at_cell.update_attributes(value: 'All Shipped')
    end

    if @msgs.any?
      @msgs.prepend "WIP Updated for #{row_data['Description']}"
    else
      []
    end

  rescue StandardError => e
    @msgs << e.message
    ErrorMailer.webhook_notification_email(@msgs, params).deliver
    []
  end

  def custom_list
    @custom_list ||= Refinery::CustomLists::CustomList.find_by_title!(CUSTOM_LIST_TITLE)
  end

  def airtable_app_column
    @airtable_app_column ||= custom_list.list_columns.find_by_title!('Airtable App Id')
  end

  def filter_column
    @filter_column ||= custom_list.list_columns.find_by_title!('Filter')
  end

  def last_updated_at_column
    @last_updated_at_column ||= custom_list.list_columns.find_by_title!('Last Updated At')
  end

  def status_column
    @status_column ||= custom_list.list_columns.find_by_title!('Status')
  end

  def airtable_orders_for(airtable_app_id, filter)
    orders = wip_airtable(airtable_app_id).all(view: AT_WIP_VIEW)

    # Add order data
    orders.select { |order| order['Order Status'] != 'CANCELLED' && (filter.blank? || order['Supplier'][0] == filter) }
  end

  def wip_airtable(airtable_app_id)
    @wip_airtables ||= {}
    @wip_airtables[airtable_app_id] ||= Airtable::Client.new(ENV['AIRTABLE_KEY']).table(airtable_app_id, AT_ORDER_SHEET)
  end

end
