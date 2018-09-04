require 'xeroizer'

module Refinery
  module Employees
    class XeroClient
      YOUR_OAUTH_KEYFILE_PATH     = ENV['XERO_KEYFILE_PATH']

      def initialize(xero_api_key_file)
        raise 'No Api Key File present' if xero_api_key_file.nil?

        @xero_api_key_file = xero_api_key_file
      end

      def sync_accounts
        begin
          # Flag all removed accounts, as inactive.
          ::Refinery::Employees::XeroAccount.
              where('inactive = ? AND guid NOT IN (?)', false, all_accounts.map(&:account_id)<<-1).
              update_all({ inactive: true })

          all_accounts.all? do |account|
            ::Refinery::Employees::XeroAccount.sync_from_xero! account
          end

        rescue StandardError => e
          false
        end
      end

      def sync_contacts
        begin
          ::Refinery::Employees::XeroContact.
              where('inactive = ? AND guid IS NOT NULL AND guid <> "" AND guid NOT IN (?)', false, all_contacts.map(&:contact_id)<<-1).
              update_all({ inactive: true })

          all_contacts.all? do |contact|
            ::Refinery::Employees::XeroContact.sync_from_xero! contact
          end

        rescue StandardError => e
          false
        end
      end

      def load_xero_guids
        begin
          all_users.map { |user| "#{user.user_id} (#{user.first_name} #{user.last_name})" }
        rescue StandardError => e
          []
        end
      end

      def client
        @client ||=
          if pem_file_path.present?
            Xeroizer::PrivateApplication.new(@xero_api_key_file.decrypt_consumer_key, @xero_api_key_file.decrypt_consumer_secret, pem_file_path)
          else
            raise StandardError, 'Pem File missing'
          end
      end

    private
      def all_accounts
        @all_accounts ||= client.Account.all(where: 'type != "BANK"')
      end

      def all_contacts
        @all_contacts ||= client.Contact.all
      end

      def all_users
        @all_users ||= client.User.all
      end

      def pem_file_path
        return @pem_file_path if @pem_file_path.present?

        @pem = Tempfile.new(['privatekey', '.pem'])
        @pem.write @xero_api_key_file.key_content
        @pem.rewind

        @pem_file_path = @pem.path
      end

    end
  end
end
