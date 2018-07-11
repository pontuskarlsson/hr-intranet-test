class HappyRabbitMailer < ApplicationMailer

  # data is a Hash where each key is the column from the custom list WIP Schedule
  def wip_schedule_email(data, file_path)
    attachments[file_path.split('/').last] = File.read(file_path)
    mail(from: 'wip_status@happyrabbit.com', to: data['Recipients'], subject: "WIP Status update: #{data['Description']}")
  end

  def services_notification_email(msgs)
    @msgs = msgs
    mail(to: emails_for_role('Services'), subject: "Services Notification - #{Date.today.to_s}")
  end

  protected

  def emails_for_role(title)
    role = Refinery::Role.find_by_title(title)
    if role.present?
      role.users.pluck(:email).join(', ')
    else
      ''
    end
  end

end
