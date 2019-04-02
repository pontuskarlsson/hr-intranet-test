require 'zendesk_api'

module Portal
  module Zendesk
    class Client

      def self.client
        ZendeskAPI::Client.new do |config|
          # Mandatory:
          config.url = 'https://happyrabbit.zendesk.com/api/v2' # e.g. https://mydesk.zendesk.com/api/v2

          # Basic / Token Authentication
          config.username = ENV['ZENDESK_USERNAME']
          config.password = ENV['ZENDESK_PASSWORD']

          # Logger prints to STDERR by default, to e.g. print to stdout:
          require 'logger'
          config.logger = Logger.new(STDOUT)
        end
      end

    end
  end
end