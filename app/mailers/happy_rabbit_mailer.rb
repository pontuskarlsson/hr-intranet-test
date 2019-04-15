class HappyRabbitMailer < ApplicationMailer

  # data is a Hash where each key is the column from the custom list WIP Schedule
  def wip_schedule_email(data, file_path, file_name)
    attachments[file_name] = File.read(file_path)
    mail(from: 'wip_status@happyrabbit.com', to: data['Recipients'], subject: "WIP Status update: #{data['Description']}")
  end

  def services_notification_email(description, notice, orders)
    @notice = notice
    @orders = orders
    mail(to: emails_for_role('Services'), subject: "Services Notification - #{description} - #{Date.today.to_s}")
  end

  protected

  def emails_for_role(title)
    role = Refinery::Authentication::Devise::Role.find_by_title(title)
    if role.present?
      role.users.pluck(:email).join(', ')
    else
      ''
    end
  end

end
