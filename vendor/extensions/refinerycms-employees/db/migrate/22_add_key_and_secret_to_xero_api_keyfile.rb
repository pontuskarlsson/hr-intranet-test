class AddKeyAndSecretToXeroApiKeyfile < ActiveRecord::Migration

  def change
    add_column :refinery_xero_api_keyfiles, :consumer_key, :string
    add_column :refinery_xero_api_keyfiles, :consumer_secret, :string
    add_column :refinery_xero_api_keyfiles, :encryption_key, :string
  end

end
