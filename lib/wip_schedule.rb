class WipSchedule

  CUSTOM_LIST_TITLE = 'WIP Schedule'

  COLUMNS = {
      "id" => { column: { hidden: true } },
      "Order Type" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Style No" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Style Name" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Description" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Colour Name" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
      "Order Date" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Qty" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Customer PO#" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "HR PO#" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Ship To" => { column: { width: '10' }, format: { pattern_fg_color: :silver, pattern: 1 } },

      "Req. Ex. Fact. Date" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "1st Conf. Ex. Fact. Date" => {},

      "Orig: Trims In-House" => {},
      "Upd: Trims In-House" => {},
      "Act: Trims In-House" => {},

      "Orig: Fabric In-House" => {},
      "Upd: Fabric In-House" => {},
      "Act: Fabric In-House" => {},

      "Orig: Cutting Complete" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Cutting Complete" => {},
      "Act: Cutting Complete" => {},

      "Orig: Sewing Complete" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Sewing Complete" => {},
      "Act: Sewing Complete" => {},

      "Orig: Final Inspection" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Final Inspection" => {},
      "Act: Final Inspection" => {},

      "Orig: Shipment Sample Sent" => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Shipment Sample Sent" => {},
      "Act: Shipment Sample Sent" => {},

      "Orig: Ex. Fact." => { format: { pattern_fg_color: :silver, pattern: 1 } },
      "Upd: Ex. Fact." => {},
      "Act: Ex. Fact." => {}
  }.freeze

  ALLOW_UPDATES = [
      "1st Conf. Ex. Fact. Date",

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
      "Act: Ex. Fact."
  ]

  ORDER_WORKSHEET = 'Orders'

  AT_ORDER_SHEET = 'Requests / Orders'
  AT_WIP_VIEW = 'WIP'

  def initialize()

  end

  def create_workbook_from(airtable_app_id)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet name: ORDER_WORKSHEET

    # Add column headers and set column formats
    COLUMNS.each_pair.each_with_index do |(column, options), column_i|
      sheet1[0, column_i] = column
      if options[:format]
        sheet1.format_column column_i, Spreadsheet::Format.new(options[:format])
      end
    end

    # Load data from Airtable
    client = Airtable::Client.new(ENV['AIRTABLE_KEY'])
    orders = client.table(airtable_app_id, AT_ORDER_SHEET).all(view: AT_WIP_VIEW)

    # Add order data
    orders.each_with_index do |order, order_i|
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

        elsif column == 'Orig: Ex. Fact.'
          # Ignore the Orig: Ex. Fact. because it is read only
        elsif column[/^Orig: /]
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
    end

    book
  end


  def update_wip_orders(filename)
    book = Spreadsheet.open filename
    sheet = book.worksheet ORDER_WORKSHEET

    @msgs = []

    airtable_app_id = sheet[0,0]

    # Makes sure the airtable app id does exist in our custom list
    list_cell = Refinery::CustomLists::ListCell.
        joins(:list_row).
        where(list_rows: {custom_list_id: custom_list.id}, list_column_id: airtable_app_column.id).
        find_by_value!(CUSTOM_LIST_TITLE)

    client = Airtable::Client.new(ENV['AIRTABLE_KEY'])
    table = client.table(airtable_app_id, AT_ORDER_SHEET)
    orders = table.all(view: AT_WIP_VIEW)

    orders.each do |order|
      if (excel_order = sheet.rows.detect { |row| row[0] == order['id'] }).present?
        changed_fields = {}
        ALLOW_UPDATES.each do |col|
          if order[col].to_s != excel_order[COLUMNS.keys.index(col)].to_s
            order[col] = excel_order[COLUMNS.keys.index(col)].to_s
            changed_fields[col] = excel_order[COLUMNS.keys.index(col)].to_s
          end
        end
        if changed_fields.any?
          @msgs << "Order #{order["HR PO#"]} was updated with: #{changed_fields.map { |k,v| "#{k}: #{v}" }.join(', ')}"
          table.update_record_fields(order.id, changed_fields)
        end

      else
        @msgs << "Could not find the order #{order["HR PO#"]} in the excel file."
      end
    end

    # If we got all the way here, we assume it was okay and flag that we received an update today
    updated_at_cell = list_cell.list_row.list_cells.find_by_list_column_id!(last_updated_at_column.id)
    updated_at_cell.update_attributes(value: Date.today)

    @msgs

  rescue StandardError => e
    @msgs << e.message
  end

  def custom_list
    @custom_list ||= Refinery::CustomLists::CustomList.find_by_title!(CUSTOM_LIST_TITLE)
  end

  def airtable_app_column
    @airtable_app_column ||= custom_list.list_columns.find_by_title!('Airtable App Id')
  end

  def last_updated_at_column
    @last_updated_at_column ||= custom_list.list_columns.find_by_title!('Last Updated At')
  end

end
