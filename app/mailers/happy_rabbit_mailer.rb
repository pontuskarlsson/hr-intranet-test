class HappyRabbitMailer < ApplicationMailer

  # data is a Hash where each key is the column from the custom list WIP Schedule
  def wip_schedule_email(data, file_path)
    attachments[file_path.split('/').last] = File.read(file_path)
    mail(from: 'wip_status@happyrabbit.com', to: data['Recipients'], subject: "WIP Status update: #{data['Description']}")
  end

end
