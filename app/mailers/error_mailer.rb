class ErrorMailer < ApplicationMailer

  def error_email(error, additional = [])
    @error = error
    @additional = additional
    mail(to: 'daniel.viklund@happyrabbit.com', subject: 'An error occoured on the Intranet')
  end

  def notification_email(msgs)
    @msgs = msgs
    mail(to: 'daniel.viklund@happyrabbit.com', subject: 'Intranet: Notification')
  end

  def webhook_error_email(error, params)
    @error = error
    @params = params
    @filename = params[:file].respond_to?(:original_filename) && params[:file].original_filename || 'N/A'
    mail(to: 'daniel.viklund@happyrabbit.com', subject: 'Webhook Error')
  end

  def webhook_notification_email(msgs, params)
    @msgs = Array(msgs)
    @params = params
    @filename = params[:file].respond_to?(:original_filename) && params[:file].original_filename || 'N/A'
    mail(to: 'daniel.viklund@happyrabbit.com', subject: 'Webhook Notification')
  end

end
