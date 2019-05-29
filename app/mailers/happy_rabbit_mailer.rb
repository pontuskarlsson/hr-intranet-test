class HappyRabbitMailer < ApplicationMailer
  layout 'happy_rabbit_mailer'

  # data is a Hash where each key is the column from the custom list WIP Schedule
  def wip_schedule_email(data, file_path, file_name)
    @header = 'WIP Schedule'
    attachments[file_name] = File.read(file_path)
    mail(from: 'wip_status@happyrabbit.com', to: data['Recipients'], subject: "WIP Status update: #{data['Description']}")
  end

  def inspection_result_email(inspection)
    @header = 'QC Inspection Report'
    @inspection = inspection

    users_for_role('Services').each do |user|
      @user = user
      mail(to: user.email, subject: "#{@header} - #{Date.today.to_s}")
    end
  end

  def services_notification_email(description, notice, orders)
    @header = 'Services Notification'
    @notice = notice
    mail(to: emails_for_role('Services'), subject: "#{@header} - #{description} - #{Date.today.to_s}")
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

  def users_for_role(title)
    role = Refinery::Authentication::Devise::Role.find_by_title(title)
    if role.present?
      role.users
    else
      []
    end
  end

end
