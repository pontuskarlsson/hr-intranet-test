class ErrorMailer < ApplicationMailer

  def error_email(error)
    @error = error
    mail(to: 'daniel@happyrabbit.com', subject: 'An error occoured on the Intranet')
  end

  def schedule_error_email(error, params)
    @error = error
    @params = params
    @filename = params[:file].respond_to?(:original_filename) && params[:file].original_filename || 'N/A'
    mail(to: 'daniel@happyrabbit.com', subject: 'QC Schedule: Error')
  end

  def schedule_notification_email(msgs, params)
    @msgs = msgs
    @params = params
    @filename = params[:file].respond_to?(:original_filename) && params[:file].original_filename || 'N/A'
    mail(to: 'daniel@happyrabbit.com', subject: 'QC Schedule: Notification')
  end

end
