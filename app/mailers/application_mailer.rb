class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: 'info@happyrabbit.com'
  layout 'mailer'
end
