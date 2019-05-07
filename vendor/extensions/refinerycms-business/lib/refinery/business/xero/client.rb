require 'xeroizer'

module Refinery
  module Business
    module Xero
      class Client

        def initialize(account)
          @account = account
        end

        def client
          @client ||=
              if pem_file_path.present?
                Xeroizer::PrivateApplication.new(@account.decrypt_consumer_key, @account.decrypt_consumer_secret, pem_file_path)
              else
                raise StandardError, 'Pem File missing'
              end
        end

        private

        def pem_file_path
          return @pem_file_path if @pem_file_path.present?
          return nil if @account.key_content.blank?

          @pem = Tempfile.new(['privatekey', '.pem'])
          @pem.write @account.key_content
          @pem.rewind

          @pem_file_path = @pem.path
        end

      end
    end
  end
end
