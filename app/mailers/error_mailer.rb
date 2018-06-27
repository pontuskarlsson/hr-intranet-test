class ErrorMailer < ApplicationMailer

  def error_email(error)
    @error = error
    mail(to: 'daniel@happyrabbit.com', subject: 'An error occoured on the Intranet')
  end

  def schedule_error_email(error, xlsx)
    @error = error
    @xlsx = xlsx
    mail(to: 'daniel@happyrabbit.com', subject: 'QC Schedule: Error')
  end

  def schedule_notification_email(msgs, xlsx)
    @msgs = msgs
    @xlsx = xlsx
    mail(to: 'daniel@happyrabbit.com', subject: 'QC Schedule: Notification')
  end

end
