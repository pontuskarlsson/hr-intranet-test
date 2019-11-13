# This migration comes from refinery_business (originally 11)
class CreateBusinessAccounts < ActiveRecord::Migration

  def change
    create_table :refinery_business_accounts do |t|
      t.string   :organisation,    limit: 255
      t.text     :key_content,     limit: 65535
      t.string   :consumer_key,    limit: 255
      t.string   :consumer_secret, limit: 255
      t.string   :encryption_key,  limit: 255
      t.text     :bank_details

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_accounts, :organisation

    add_index :refinery_business_accounts, :position
  end

end
