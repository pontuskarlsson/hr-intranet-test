class HappyRabbitMailer < ApplicationMailer
  layout 'happy_rabbit_mailer'

  # data is a Hash where each key is the column from the custom list WIP Schedule
  def wip_schedule_email(data, creator)
    @header = 'WIP Schedule'
    @creator = creator
    file_name = "#{data['Description']}-#{Date.today.to_s}.xls"
    attachments[file_name] = File.read(creator.wip_file_path)
    mail(from: 'wip_status@happyrabbit.com', to: data['Recipients'], bcc: ['daniel.viklund@happyrabbit.com'], subject: "WIP Status update: #{data['Description']}")
  end

  def inspection_result_email(user, inspection)
    @header = 'QC Inspection Report'

    @inspection = inspection
    @user = user
    mail(to: user.email, bcc: ['daniel.viklund@happyrabbit.com'], subject: "#{@header} - #{Date.today.to_s}")
  end

  def services_notification_email(results)
    recipients, description, @notice, @orders = results[:recipients], results[:description], results[:notice], results[:orders]
    @header = 'WIP Update Notification'
    mail(to: recipients, bcc: ['daniel.viklund@happyrabbit.com'], subject: "#{@header} - #{description} - #{Date.today.to_s}")
  end

end
