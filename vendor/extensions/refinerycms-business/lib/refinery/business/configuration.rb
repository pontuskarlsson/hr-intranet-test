module Refinery
  module Business
    include ActiveSupport::Configurable

    config_accessor :stripe_success_url, :stripe_cancel_url

    self.stripe_success_url = nil
    self.stripe_cancel_url = nil
  end
end
