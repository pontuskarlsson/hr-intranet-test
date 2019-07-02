# encoding: utf-8
Refinery::Authentication::Devise.configure do |config|
  # Configure whether to allow superuser to assign roles
  config.superuser_can_assign_roles = true

  # Configure notification email from name
  config.email_from_name = 'noreply'
end
