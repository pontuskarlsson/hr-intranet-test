class ErrorMailer < ApplicationMailer

  def error_email(error)
    @error = error
    mail(to: 'daniel@happyrabbit.com', subject: 'An error occoured on the Intranet')
  end

end
