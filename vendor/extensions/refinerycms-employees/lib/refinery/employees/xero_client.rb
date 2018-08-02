require 'xeroizer'

module Refinery
  module Employees
    class XeroClient
      YOUR_OAUTH_CONSUMER_KEY     = ENV['XERO_CONSUMER_KEY']
      YOUR_OAUTH_CONSUMER_SECRET  = ENV['XERO_CONSUMER_SECRET']
      YOUR_OAUTH_KEYFILE_PATH     = ENV['XERO_KEYFILE_PATH']


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
            Xeroizer::PrivateApplication.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET, pem_file_path)
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
        @pem_file_path ||=
            if YOUR_OAUTH_KEYFILE_PATH.present?
              YOUR_OAUTH_KEYFILE_PATH[0] == '/' ? YOUR_OAUTH_KEYFILE_PATH : File.join(Rails.root, YOUR_OAUTH_KEYFILE_PATH)
            else
              if (xero_api_keyfile = ::Refinery::Employees::XeroApiKeyfile.first).present?
                @pem = Tempfile.new(['privatekey', '.pem'])
                @pem.write xero_api_keyfile.key_content
                @pem.rewind
                @pem.path
              end
            end
      end

    end
  end
end
