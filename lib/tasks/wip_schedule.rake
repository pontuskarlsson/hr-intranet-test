require "#{Rails.root}/lib/wip_schedule"

namespace :hr_intranet do
  namespace :wip_schedule do

    task send: :environment do
      begin
        list = WipSchedule::CustomList.new

        list.each_open_row do |row|
          creator = WipSchedule::Creator.new(row['Airtable App Id'], row['Filter'])

          if creator.create_wip_file
            file_name = "#{row['Description']}-#{Date.today.to_s}.xls"
            HappyRabbitMailer.wip_schedule_email(row, creator.wip_file_path, file_name).deliver
          end

          # Handle messages
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
