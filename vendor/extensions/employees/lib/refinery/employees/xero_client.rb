require 'xeroizer'

module Refinery
  module Employees
    module XeroClient
      YOUR_OAUTH_CONSUMER_KEY     = ENV['XERO_CONSUMER_KEY']
      YOUR_OAUTH_CONSUMER_SECRET  = ENV['XERO_CONSUMER_SECRET']

      class << self

        # Note! This method returns a new instance everytime it is called, so only call once and store
        # the instance in a variable until the batch of operations is done
        def client
          xero_api_keyfile = ::Refinery::Employees::XeroApiKeyfile.first
          if xero_api_keyfile.present?
            pem = Tempfile.new(['privatekey', '.pem'])
            pem.write xero_api_keyfile.key_content
            pem.rewind
            Xeroizer::PrivateApplication.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET, pem.path)
          else
            raise StandardError, 'Pem File missing'
          end
        end


        def sync_accounts
          begin
            client.Account.all(where: { show_in_expense_claims: true }).each do |account|
              xero_account = ::Refinery::Employees::XeroAccount.find_or_initialize_by_guid(account.account_id)
              account.attributes.each_pair do |attr, value|
                xero_account.send("#{attr}=", value) if xero_account.respond_to?("#{attr}=")
              end
              xero_account.save!
            end
          rescue StandardError => e
            binding.pry if binding.respond_to?(:pry) && Rails.env.development?
          end
        end

        def sync_contacts
          begin
            client.Contact.all.each do |contact|
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
            client.User.all.each do |user|
              guids << "#{user.user_id} (#{user.first_name} #{user.last_name})"
            end
            guids
          rescue StandardError => e
            binding.pry if binding.respond_to?(:pry) && Rails.env.development?
            []
          end
        end

      end

    end
  end
end
