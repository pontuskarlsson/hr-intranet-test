class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: "\"Happy Rabbit\" <noreply@happyrabbit.com>"

  layout 'mailer'
end
