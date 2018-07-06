namespace :hr_intranet do
  namespace :wip_schedule do

    COLUMNS = {
        "ID" => { column: { hidden: true } },
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

        "Orig: Cutting Complete" => {},
        "Upd: Cutting Complete" => {},
        "Act: Cutting Complete" => {},

        "Orig: Sewing Complete" => {},
        "Upd: Sewing Complete" => {},
        "Act: Sewing Complete" => {},

        "Orig: Final Inspection" => {},
        "Upd: Final Inspection" => {},
        "Act: Final Inspection" => {},

        "Orig: Shipment Sample Sent" => {},
        "Upd: Shipment Sample Sent" => {},
        "Act: Shipment Sample Sent" => {},

        "Orig: Ex. Fact." => { format: { pattern_fg_color: :silver, pattern: 1 } },
        "Upd: Ex. Fact." => {},
        "Act: Ex. Fact." => {}
    }

    task send: :environment do
      begin
        msgs = []

        list = Refinery::CustomLists::CustomList.find_by_title('WIP Schedule')

        if list.nil?
          msgs << 'Could not find a list called "WIP Schedule".'

        else
          list.list_rows.includes(list_cells: :list_column).each do |list_row|

            # Building up a Hash with the following structure
            #
            # data = {
            #     'Airtable App Id' => 'app12345',
            #     'Recipients' => 'john@doe.com'
            # }
            #
            data = list_row.list_cells.inject({}) { |acc, list_cell|
              acc.merge(list_cell.list_column.title => list_cell.value)
            }

            if data['Status'] == 'Open'

              client = Airtable::Client.new(ENV['AIRTABLE_KEY'])

              orders = client.table(data['Airtable App Id'], 'Requests / Orders').all(view: 'WIP')

              book = Spreadsheet::Workbook.new
              sheet1 = book.create_worksheet name: 'Orders'

              # Add column headers and set column formats
              COLUMNS.each_pair.each_with_index do |(column, options), column_i|
                sheet1[0, column_i] = column
                if options[:format]
                  sheet1.format_column column_i, Spreadsheet::Format.new(options[:format])
                end
              end

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

              # Save the file
              @path = File.join(ENV['AIRTABLE_TMP_DIR'], "#{data['Description']}-#{Date.today.to_s}.xls".gsub(/[^0-9A-Za-z.\-]/, '_').gsub(/[_]+/, '_'))
              book.write(@path)

              HappyRabbitMailer.wip_schedule_email(data, @path).deliver

              if msgs.any?
                msgs << "The above came from the Airtable #{data['Airtable App Id']}."
              end
            end
          end
        end

        if msgs.any?
          ErrorMailer.notification_email(msgs).deliver
        end

      rescue StandardError => e
        ErrorMailer.error_email(e).deliver

      ensure
        # Remove the file when done
        if Rails.env.production?
          File.unlink @path if @path && File.exists?(@path)
        end
      end
    end

  end
end
