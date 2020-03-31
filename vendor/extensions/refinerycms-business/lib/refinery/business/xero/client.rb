require 'xeroizer'

module Refinery
  module Business
    module Xero
      class Client

        attr_reader :tenant_id

        def initialize(xero_authorization)
          @xero_authorization = xero_authorization
          @authentication = xero_authorization.omni_authentication
          @tenant_id = xero_authorization.tenant_id
        end

        def client
          @client ||= Xeroizer::OAuth2Application.new(
              ENV['XERO_CLIENT_ID'],
              ENV['XERO_CLIENT_SECRET'],
              access_token: access_token,
              tenant_id: tenant_id
          )
          # @client ||=
          #     if pem_file_path.present?
          #       Xeroizer::PrivateApplication.new(@account.decrypt_consumer_key, @account.decrypt_consumer_secret, pem_file_path)
          #     else
          #       raise StandardError, 'Pem File missing'
          #     end
        end

        private

        # def pem_file_path
        #   return @pem_file_path if @pem_file_path.present?
        #   return nil if @account.key_content.blank?
        #
        #   @pem = Tempfile.new(['privatekey', '.pem'])
        #   @pem.write @account.key_content
        #   @pem.rewind
        #
        #   @pem_file_path = @pem.path
        # end

        def access_token
          @access_token ||=
              if @authentication.token_expired?(1.minute)
                refresh_token
              else
                @authentication.token
              end
        end

        def refresh_token
          system_time = Time.now.to_i
          xero_token_endpoint = 'https://identity.xero.com/connect/token'
          refresh_request_body_hash = {
              grant_type: 'refresh_token',
              refresh_token: @authentication.refresh_token
          }

          resp = Faraday.post(xero_token_endpoint) do |req|
            req.headers['Authorization'] = basic_auth
            req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
            req.body = URI.encode_www_form(refresh_request_body_hash)
          end

          if resp.status == 200
            resp_hash = JSON.parse(resp.body)

            @authentication.token = resp_hash['access_token']
            @authentication.refresh_token = resp_hash['refresh_token']
            @authentication.token_expires = system_time + resp_hash['expires_in']
            @authentication.save
          else
            raise 'Failed to refresh access token'
          end
          @authentication.token
        end

        def basic_auth
          'Basic ' + Base64.strict_encode64(ENV['XERO_CLIENT_ID'] + ':' + ENV['XERO_CLIENT_SECRET'])
        end

      end
    end
  end
end
