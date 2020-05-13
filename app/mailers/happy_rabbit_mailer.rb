class HappyRabbitMailer < ApplicationMailer
  layout 'happy_rabbit_mailer'

  # data is a Hash where each key is the column from the custom list WIP Schedule
  def wip_schedule_email(data, creator)
    @header = 'WIP Schedule'
    @creator = creator
    file_name = "#{data['Description']}-#{Date.today.to_s}.xls"
    attachments[file_name] = File.read(creator.wip_file_path)

    mail(
        from: "\"Happy Rabbit WIP Status\" <wip_status@happyrabbit.com>",
        to: data['Recipients'],
        subject: "WIP Status Request: #{data['Description']}, #{Date.today.to_s}",
        cc: Refinery::Authentication::Devise::User.for_role(Refinery::Shipping::ROLE_INTERNAL).to_recipients
    )
  end

  def wip_update_notification_email(results)
    recipients, description, @notice, @orders = results[:recipients], results[:description], results[:notice], results[:orders]
    @header = 'WIP Update Notification'

    mail(
        to: recipients,
        subject: "#{@header} - #{description} - #{Date.today.to_s}",
        cc: Refinery::Authentication::Devise::User.for_role(Refinery::Shipping::ROLE_INTERNAL).to_recipients
    )
  end

  def welcome1(user)
    @user = user
    @header = 'Welcome to Happy Rabbit!'

    mail(
        from: "\"Happy Rabbit\" <hello@happyrabbit.com>",
        to: user.email,
        subject: "Welcome to Happy Rabbit!"
    )
  end

end
