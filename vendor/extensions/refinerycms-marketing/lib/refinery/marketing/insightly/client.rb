require 'faraday'

module Refinery
  module Marketing
    module Insightly
      class Client

        ENDPOINT = 'https://api.insight.ly/v3.1/'

        def initialize(token = ENV['INSIGHTLY_TOKEN'])
          @headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          @headers['Authorization'] = "Basic #{Base64.encode64(token)}" if token.present?
        end

        def list_of(resource, batch_size = 100)
          Refinery::Marketing::Insightly::ResourceList.new(self, resource, batch_size)
        end

        def get(resource, params = {})
          request :get, resource, params
        end

        def put(resource, params)
          if Insightly.configuration.updates_allowed
            request :put, resource, params
          end
        end

        def post(resource, params)
          if Insightly.configuration.updates_allowed
            request :post, resource, params
          end
        end

        # def delete(resource, params = {})
        #   if Insightly.configuration.updates_allowed
        #     request :delete, resource, params
        #   end
        # end

        def raw(method, url, params = {}, extra_headers = {})
          client.send(method) do |req|
            req.url url
            req.headers.merge!(@headers.merge(extra_headers))
            if method == :get
              req.params.merge!(params)
            else
              req.body = params.to_json
            end
          end
        end

        private

        def request(method, url, params)
          resp = client.send(method) do |req|
            req.url url
            req.headers.merge!(@headers)
            if method == :get
              req.params.merge!(params)
            else
              req.body = params.to_json
            end
          end

          JSON.parse resp.body
        end

        def client
          Faraday.new(url: ENDPOINT)
        end

      end
    end
  end
end
