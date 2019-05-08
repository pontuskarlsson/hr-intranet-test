require 'api_client'

module Refinery
  module Marketing
    module Insightly
      class Client

        ENDPOINT = 'https://api.insightly.com/v3.1/'

        def initialize(token = ENV['INSIGHTLY_TOKEN'])
          @headers = { 'Accept' => 'application/json' }
          @headers['Authorization'] = "Basic #{Base64.encode64(token)}" if token.present?
        end

        def list_of(resource)
          Refinery::Marketing::Insightly::ResourceList.new(client, resource)
        end

        def get(resource, params = {})
          client.get(resource, params)
        end

        def put(resource, params)
          if Insightly.configuration.updates_allowed
            client.put(resource, params)
          end
        end

        def post(resource, params)
          if Insightly.configuration.updates_allowed
            client.post(resource, params)
          end
        end

        def delete(resource, params = {})
          if Insightly.configuration.updates_allowed
            client.delete(resource, params)
          end
        end

        private

        def client
          ApiClient::Base.headers(@headers).endpoint(ENDPOINT)
        end

      end
    end
  end
end
