require "#{Rails.root}/lib/portal_subdomain"

# encoding: utf-8
Refinery::Business.configure do |config|
  config.stripe_success_url = "#{::PortalSubdomain.protocol_domain}/business/purchases/success"
  config.stripe_cancel_url = "#{::PortalSubdomain.protocol_domain}/business/purchases/cancel"
end
