namespace :hr_intranet do
  namespace :wip_schedule do

    task send: :environment do
      begin
        msgs = []

        wip_schedule = WipSchedule.new
        list = wip_schedule.custom_list

        list.data.each do |row|
          if row['Status'] == 'Open'

            # Create an excel file based on the airtable orders
            book = wip_schedule.create_workbook_from(row['Airtable App Id'], row['Filter'])

            # Save the file
            @path = File.join(ENV['AIRTABLE_TMP_DIR'], "#{row['Description']}-#{Date.today.to_s}.xls".gsub(/[^0-9A-Za-z.\-]/, '_').gsub(/[_]+/, '_'))
            book.write(@path)

#            HappyRabbitMailer.wip_schedule_email(row, @path).deliver

            if msgs.any?
              msgs << "The above came from the Airtable #{row['Airtable App Id']}."
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
