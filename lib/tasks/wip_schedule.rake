namespace :hr_intranet do
  namespace :wip_schedule do

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

              wip_schedule = WipSchedule.new(data['Airtable App Id'])

              # Create an excel file based on the airtable orders
              book = wip_schedule.create_workbook

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
