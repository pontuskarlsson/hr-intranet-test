class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  include Devise::Controllers::UrlHelpers

  default from: "\"Happy Rabbit\" <noreply@happyrabbit.com>"

  layout 'mailer'
end
