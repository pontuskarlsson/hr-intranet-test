require 'xeroizer'

module Refinery
  module Business
    module Xero
      class Client

        attr_reader :access_token, :tenant_id

        def initialize(access_token, tenant_id)
          #@account = account
          @access_token, @tenant_id = access_token, tenant_id
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

      end
    end
  end
end
