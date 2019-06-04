# encoding: utf-8
Refinery::Authentication::Devise.configure do |config|
  # Configure whether to allow superuser to assign roles
  config.superuser_can_assign_roles = true

  # Configure notification email from name
  config.email_from_name = 'noreply'
end


Refinery::Authentication::Devise::UserMailer.class_eval do
  add_template_helper(EmailHelper)

  layout 'happy_rabbit_mailer'

  def reset_notification(user, request, reset_password_token)
    @header = 'Reset Password'
    @user = user
    @url = refinery.edit_authentication_devise_user_password_url({
        :host => request.host_with_port,
        :reset_password_token => reset_password_token
    })

    mail(:to => user.email,
         :subject => t('subject', :scope => 'refinery.authentication.devise.user_mailer.reset_notification'),
         :from => "\"#{Refinery::Core.site_name}\" <noreply@happyrabbit.com>")
  end
end
