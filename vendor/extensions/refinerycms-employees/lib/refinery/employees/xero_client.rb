require 'xeroizer'

module Refinery
  module Employees
    class XeroClient
      YOUR_OAUTH_CONSUMER_KEY     = ENV['XERO_CONSUMER_KEY']
      YOUR_OAUTH_CONSUMER_SECRET  = ENV['XERO_CONSUMER_SECRET']
      YOUR_OAUTH_KEYFILE_PATH     = ENV['XERO_KEYFILE_PATH']


      def sync_accounts
        begin
          # Start with removing XeroAccounts that do not exist in Xero, otherwise we might
          # validation errors for duplicated names if a new Account has been added with the
          # same name as a previous Account.
          ::Refinery::Employees::XeroAccount.
              where('inactive = ? AND guid NOT IN (?)', false, all_accounts.map(&:account_id)<<-1).
              update_all({ inactive: true })

          all_accounts.each do |account|
            xero_account = ::Refinery::Employees::XeroAccount.find_or_initialize_by_guid(account.account_id)
            account.attributes.each_pair do |attr, value|
              xero_account.send("#{attr}=", value) if xero_account.respond_to?("#{attr}=")
            end
            xero_account.save!
          end

          true # Returns true if everything went okay

        rescue StandardError => e
          binding.pry if binding.respond_to?(:pry) && Rails.env.development?
          false # Returns false if something went wrong
        end
      end

      def sync_contacts
        begin
          ::Refinery::Employees::XeroContact.
              where('inactive = ? AND guid IS NOT NULL AND guid <> "" AND guid NOT IN (?)', false, all_contacts.map(&:contact_id)<<-1).
              update_all({ inactive: true })

          all_contacts.each do |contact|
            xero_contact = ::Refinery::Employees::XeroContact.find_or_initialize_by_guid(contact.contact_id)
            contact.attributes.each_pair do |attr, value|
              xero_contact.send("#{attr}=", value) if xero_contact.respond_to?("#{attr}=")
            end
            xero_contact.save!
          end
        rescue StandardError => e
          binding.pry if binding.respond_to?(:pry) && Rails.env.development?
        end
      end

      def load_xero_guids
        begin
          guids = []
          all_users.each do |user|
            guids << "#{user.user_id} (#{user.first_name} #{user.last_name})"
          end
          guids
        rescue StandardError => e
          binding.pry if binding.respond_to?(:pry) && Rails.env.development?
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
        @all_accounts ||= client.Account.all(where: { show_in_expense_claims: true })
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
                pem = Tempfile.new(['privatekey', '.pem'])
                pem.write xero_api_keyfile.key_content
                pem.rewind
                pem.path
              end
            end
      end

    end
  end
end
