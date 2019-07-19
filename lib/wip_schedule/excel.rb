module WipSchedule
  class Excel
    
    PATTERN_READ_ONLY = { pattern_fg_color: :silver, pattern: 1 }.freeze

    COLUMNS = {
        "id" =>                           { column: { hidden: true } },
        "Project Code" =>                 { column: { width: '30' }, type: :text,     format: PATTERN_READ_ONLY },
        "Customer PO#" =>                 { column: { width: '15' }, type: :text,     format: PATTERN_READ_ONLY },
        "PO Line Item" =>                 { column: { width: '15' }, type: :text,     format: PATTERN_READ_ONLY },
        "HR PO#" =>                       { column: { width: '10' }, type: :text,     format: PATTERN_READ_ONLY },
        "Order Date" =>                   { column: { width: '10' }, type: :date,     format: PATTERN_READ_ONLY },
        "Order Type" =>                   { column: { width: '10' }, type: :text,     format: PATTERN_READ_ONLY },
        "Order Status" =>                 { column: { width: '10' }, type: :text,     format: PATTERN_READ_ONLY },

        "Style No" =>                     { column: { width: '10' }, type: :text,     format: PATTERN_READ_ONLY },
        "Style Name" =>                   { column: { width: '20' }, type: :text,     format: PATTERN_READ_ONLY },
        "Description" =>                  { column: { width: '20' }, type: :text,     format: PATTERN_READ_ONLY },
        "Theme" =>                        { column: { width: '20' }, type: :text,     format: PATTERN_READ_ONLY },
        "Colour Name" =>                  { column: { width: '20' }, type: :text,     format: PATTERN_READ_ONLY },

        "Orig. Qty" =>                    { column: { width: '10' }, type: :number,   format: PATTERN_READ_ONLY },
        "Rev. Qty" =>                     { column: { width: '10' }, type: :number,   format: PATTERN_READ_ONLY },
        "Act. Qty" =>                     { column: { width: '10' }, type: :number },

        "Customer PO Currency" =>         { column: { width: '20' }, type: :text,     format: PATTERN_READ_ONLY },
        "Customer PO Price / SKU" =>      { column: { width: '20' }, type: :currency, format: PATTERN_READ_ONLY },
        "Customer PO Total Cost" =>       { column: { width: '20' }, type: :currency, format: PATTERN_READ_ONLY },
        "Vendor Conf. PO Price / SKU" =>  { column: { width: '30' }, type: :currency },

        "Ship To" =>                      { column: { width: '10' }, type: :text,     format: PATTERN_READ_ONLY },
        "Ship Mode" =>                    { column: { width: '10' }, type: :text,     format: PATTERN_READ_ONLY },
        "Vendor PI#" =>                   { column: { width: '15' }, type: :text },
        "Vendor Invoice#" =>              { column: { width: '15' }, type: :text },

        "Req. Ex. Fact. Date" =>          { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "1st Conf. Ex. Fact. Date" =>     { column: { width: '15' }, type: :date },
        "Re-Negoti. Ex. Fact. Date" =>    { column: { width: '15' }, type: :date },

        "Orig: Trims In-House" =>         { column: { width: '15' }, type: :date },
        "Upd: Trims In-House" =>          { column: { width: '15' }, type: :date },
        "Act: Trims In-House" =>          { column: { width: '15' }, type: :date },

        "Orig: Fabric In-House" =>        { column: { width: '15' }, type: :date },
        "Upd: Fabric In-House" =>         { column: { width: '15' }, type: :date },
        "Act: Fabric In-House" =>         { column: { width: '15' }, type: :date },

        "Orig: Cutting Complete" =>       { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Upd: Cutting Complete" =>        { column: { width: '15' }, type: :date },
        "Act: Cutting Complete" =>        { column: { width: '15' }, type: :date },

        "Orig: Sewing Complete" =>        { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Upd: Sewing Complete" =>         { column: { width: '15' }, type: :date },
        "Act: Sewing Complete" =>         { column: { width: '15' }, type: :date },

        "Orig: Shipping Booked" =>        { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Upd: Shipping Booked" =>         { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Act: Shipping Booked" =>         { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Freight Forwarder" =>            { column: { width: '15' }, type: :text,     format: PATTERN_READ_ONLY },
        "Shipment Reference" =>           { column: { width: '15' }, type: :text,     format: PATTERN_READ_ONLY },
        "FOB INCO Terms (Quotation)" =>   { column: { width: '15' }, type: :text,     format: PATTERN_READ_ONLY },

        "Orig: Final Inspection" =>       { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Upd: Final Inspection" =>        { column: { width: '15' }, type: :date },
        "Act: Final Inspection" =>        { column: { width: '15' }, type: :date },

        "Orig: Shipment Sample Sent" =>   { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Upd: Shipment Sample Sent" =>    { column: { width: '15' }, type: :date },
        "Act: Shipment Sample Sent" =>    { column: { width: '15' }, type: :date },

        "Orig: Ex. Fact." =>              { column: { width: '15' }, type: :date,     format: PATTERN_READ_ONLY },
        "Upd: Ex. Fact." =>               { column: { width: '15' }, type: :date },
        "Act: Ex. Fact." =>               { column: { width: '15' }, type: :date },
        "Comments" =>                     { column: { width: '30' }, type: :text }
    }.freeze

    ALLOW_UPDATES = [
        "Act. Qty",

        "Vendor PI#",
        "Vendor Invoice#",

        "Vendor Conf. PO Price / SKU",

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

    ONLY_IF_BLANK = [
        "Vendor Conf. PO Price / SKU",
        "1st Conf. Ex. Fact. Date",
        "Orig: Trims In-House",
        "Orig: Fabric In-House"
    ]


    ORDER_WORKSHEET = 'Orders'

    attr_reader :attentions

    def initialize(book)
      @book = book
      @sheet = book.worksheet(ORDER_WORKSHEET)
      @next_row_idx = 1
      @attentions = {}
    end

    def self.blank
      workbook = Spreadsheet::Workbook.new
      workbook.create_worksheet(name: ORDER_WORKSHEET)
      new workbook
    end

    def add_row(order)
      COLUMNS.each_pair.each_with_index do |(column, options), column_i|
        set_value column_i, order[column]

        format = options[:format] || {}

        if allow_updates? column, order
          if should_alert order, column
            format = value(order, column).present? ? format.merge(color: :red) : format.merge(pattern_fg_color: :red, pattern: 1)
          end
        else
          format = format.merge(PATTERN_READ_ONLY)
        end

        set_format column_i, format
      end

      @next_row_idx += 1
    end

    def allow_updates?(column, order)
      ALLOW_UPDATES.include?(column) && (!ONLY_IF_BLANK.include?(column) || value(order, column).blank?)
    end
    
    def set_value(col_idx, value)
      @sheet[@next_row_idx, col_idx] = value.is_a?(Array) ? value.join(', ') : value
    end

    def set_format(col_idx, format)
      @sheet.row(@next_row_idx).set_format(col_idx, formats_for(format))
    end

    def finalize!(app_id, filter)
      # Set column settings last, otherwise they seem to be ignored
      COLUMNS.each_pair.each_with_index do |(column, options), column_i|
        @sheet[0, column_i] = column
        if options[:format]
          @sheet.format_column column_i, formats_for(options[:format])
        end
        if options[:column]
          options[:column].each_pair do |k ,v|
            @sheet.column(column_i).send("#{k}=", v)
          end
        end
      end

      @sheet[0,0] = [app_id, filter].reject(&:blank?).join(',')

      @sheet.freeze! 0, 7
    end

    def write(file)
      @book.write(file.path)
    end

    # A method to make sure that we don't create multiple format instances for the same options.
    def formats_for(hash)
      @formats ||= {}
      @formats[hash] ||= Spreadsheet::Format.new(hash)
    end

    def should_alert(order, column)
      # Do not alert anything if order already have an Act. Ex. Fact date
      return false if value(order, 'Act: Ex. Fact.').present?

      if value(order, 'Order Status') == 'REQUESTED'
        # If the order status is requested, we only require confirmed ex. factory and PO price from vendor.
        if ['1st Conf. Ex. Fact. Date', 'Vendor Conf. PO Price / SKU'].include? column
          if value(order, column).blank?
            alert 'Requested', 'missing', order['id'], column
          else
            false
          end
        else
          false
        end

      else
        if column == '1st Conf. Ex. Fact. Date'
          if value(order, column).blank?
            alert 'Ordered', 'missing', order['id'], column
          else
            false
          end

        elsif /Orig: (Trims In-House|Fabric In-House)/.match(column)
          # Original columns should only be flagged when they are empty, since
          # if the date is outdated and nothing is entered into the Upd column,
          # then it is the Upd column that should be flagged
          if value(order, column).blank?
            alert 'Ordered', 'missing', order['id'], column
          else
            false
          end

        elsif (res = /Upd: (.*$)/.match(column)).present?
          if res[1] != 'Shipping Booked' && operation_outdated?(res[1], order)
            alert 'Ordered', 'outdated', order['id'], column
          else
            false
          end

        else
          false
        end
      end
    end

    def operation_outdated?(operation, order)
      # If this operation already has an Actual date, then it is not outdated
      return false if value(order, "Act: #{operation}").present?

      if value(order, "Upd: #{operation}").present?
        value(order, "Upd: #{operation}").to_date < Date.today

      elsif value(order, "Orig: #{operation}").present?
        value(order, "Orig: #{operation}").to_date < Date.today

      else
        false
      end
    end

    def value(order, column)
      order[column].is_a?(Array) ? order[column].join(', ') : order[column]
    end

    def find_row(id)
      @sheet.rows.detect { |row| row[0] == id }
    end

    def get_app_id
      airtable_app_id, *_ = @sheet[0,0].to_s.split(',')
      airtable_app_id
    end

    def get_filter
      _, *filter = @sheet[0,0].to_s.split(',')
      filter.join(',')
    end

    def alert(order_status, attention, order_id, column)
      @attentions[order_status] ||= {}
      @attentions[order_status][attention] ||= { orders: [], columns: [] }
      @attentions[order_status][attention][:orders] |= [order_id]
      @attentions[order_status][attention][:columns] |= [column]
      true
    end

  end
end
