# encoding: utf-8
Refinery::Marketing::Insightly.configure do |config|
  # Configure whether to allow superuser to assign roles
  config.updates_allowed = Rails.env.production?
end
