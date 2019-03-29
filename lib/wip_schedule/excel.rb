module WipSchedule
  class Excel

    COLUMNS = {
        "id" => { column: { hidden: true } },
        "Project Code" => { column: { width: '30' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Customer PO#" => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "HR PO#" => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "Order Date" => { format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Order Type" => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "Order Status" => { format: { pattern_fg_color: :silver, pattern: 1 } },

        "Style No" => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "Style Name" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Description" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Theme" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Colour Name" => { column: { width: '20' }, format: { pattern_fg_color: :silver, pattern: 1 } },

        "Orig. Qty" => { column: { width: '10' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Rev. Qty" => { column: { width: '10' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Act. Qty" => { column: { width: '10' }, type: :number },

        "Customer PO Currency" => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "Customer PO Price / SKU" => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "Customer PO Total Cost" => { format: { pattern_fg_color: :silver, pattern: 1 } },

        "Ship To" => { column: { width: '10' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Ship Mode" => { column: { width: '10' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Vendor PI#" => { column: { width: '15' } },

        "Req. Ex. Fact. Date" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "1st Conf. Ex. Fact. Date" => { column: { width: '15' }, type: :date },
        "Re-Negoti. Ex. Fact. Date" => { column: { width: '15' }, type: :date },

        "Orig: Trims In-House" => { column: { width: '15' }, type: :date },
        "Upd: Trims In-House" => { column: { width: '15' }, type: :date },
        "Act: Trims In-House" => { column: { width: '15' }, type: :date },

        "Orig: Fabric In-House" => { column: { width: '15' }, type: :date },
        "Upd: Fabric In-House" => { column: { width: '15' }, type: :date },
        "Act: Fabric In-House" => { column: { width: '15' }, type: :date },

        "Orig: Cutting Complete" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Upd: Cutting Complete" => { column: { width: '15' }, type: :date },
        "Act: Cutting Complete" => { column: { width: '15' }, type: :date },

        "Orig: Sewing Complete" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Upd: Sewing Complete" => { column: { width: '15' }, type: :date },
        "Act: Sewing Complete" => { column: { width: '15' }, type: :date },

        "Orig: Shipping Booked" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Upd: Shipping Booked" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Act: Shipping Booked" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Freight Forwarder" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "Shipment Reference" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },
        "FOB INCO Terms (Quotation)" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 } },

        "Orig: Final Inspection" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Upd: Final Inspection" => { column: { width: '15' }, type: :date },
        "Act: Final Inspection" => { column: { width: '15' }, type: :date },

        "Orig: Shipment Sample Sent" => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Upd: Shipment Sample Sent" => { column: { width: '15' }, type: :date },
        "Act: Shipment Sample Sent" => { column: { width: '15' }, type: :date },

        "Orig: Ex. Fact." => { column: { width: '15' }, format: { pattern_fg_color: :silver, pattern: 1 }, type: :date },
        "Upd: Ex. Fact." => { column: { width: '15' }, type: :date },
        "Act: Ex. Fact." => { column: { width: '15' }, type: :date },
        "Comments" => { column: { width: '30' } }
    }.freeze

    ALLOW_UPDATES = [
        "Act. Qty",

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

    def initialize(book)
      @book = book
      @sheet = book.worksheet(ORDER_WORKSHEET)
      @next_row_idx = 1
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

        if should_alert order, column
          format = value(order, column).present? ? format.merge(color: :red) : format.merge(pattern_fg_color: :red, pattern: 1)
        end

        set_format column_i, format
      end

      @next_row_idx += 1
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
        if options[:column]
          options[:column].each_pair do |k ,v|
            @sheet.column(column_i).send("#{k}=", v)
          end
        end
        if options[:format]
          @sheet.format_column column_i, formats_for(options[:format])
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
      # Do not alert anything unless order status is ORDERED
      return false if value(order, 'Order Status') == 'DRAFT' or value(order, 'Act: Ex. Fact.').present?
      return false unless ALLOW_UPDATES.include?(column)

      if column == '1st Conf. Ex. Fact. Date'
        value(order, column).blank?

      elsif /Orig: (Trims In-House|Fabric In-House)/.match(column)
        # Original columns should only be flagged when they are empty, since
        # if the date is outdated and nothing is entered into the Upd column,
        # then it is the Upd column that should be flagged
        value(order, column).blank?

      elsif (res = /Upd: (.*$)/.match(column)).present?
        res[0] != 'Shipping Booked' && operation_outdated?(res[0], order)

      else
        false
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

  end
end
