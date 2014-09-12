module XeroClient
  YOUR_OAUTH_CONSUMER_KEY     = ENV['XERO_CONSUMER_KEY']
  YOUR_OAUTH_CONSUMER_SECRET  = ENV['XERO_CONSUMER_SECRET']

  class << self

    # Note! This method returns a new instance everytime it is called, so only call once and store
    # the instance in a variable until the batch of operations is done
    def client
      pem_path = File.join(Rails.root, '.pem', 'privatekey.pem')
      if File.exist?(pem_path)
        Xeroizer::PrivateApplication.new(YOUR_OAUTH_CONSUMER_KEY, YOUR_OAUTH_CONSUMER_SECRET, pem_path)
      else
        raise StandardError('Pem File missing')
      end
    end


    def sync_accounts
      begin
        client.Account.all(where: { show_in_expense_claims: true }).each do |xero_account|
          account = ::Account.find_or_initialize_by_guid(xero_account.account_id)
          account.code = xero_account.code
          account.name = xero_account.name
          account.save!
        end
      rescue StandardError => e
        binding.pry if binding.respond_to?(:pry)
      end
    end

    def sync_contacts
      begin
        client.Contact.all.each do |xero_contact|
          contact = ::Contact.find_or_initialize_by_guid(xero_contact.contact_id)
          contact.name = xero_contact.name
          contact.save!
        end
      rescue StandardError => e
        binding.pry if binding.respond_to?(:pry)
      end
    end

  end

end
