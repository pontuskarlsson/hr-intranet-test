# Mail config
Rails.application.config.action_mailer.raise_delivery_errors = true
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
    address:              ENV['MAIL_SERVER'],
    port:                 587,
    user_name:            ENV['MAIL_USER'],
    password:             ENV['MAIL_PASS'],
    enable_starttls_auto: true
}
Rails.application.config.action_mailer.default_url_options = {
    host: ENV['MAIL_DEFAULT_HOST']
}