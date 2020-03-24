# This migration comes from refinery_marketing (originally 15)
class CreateMarketingAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_marketing_addresses do |t|
      t.integer :owner_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :province
      t.string :locale

      t.timestamps
    end
    add_index :refinery_marketing_addresses, :owner_id
    add_index :refinery_marketing_addresses, :address1
    add_index :refinery_marketing_addresses, :address2
    add_index :refinery_marketing_addresses, :city
    add_index :refinery_marketing_addresses, :country
    add_index :refinery_marketing_addresses, :postal_code
    add_index :refinery_marketing_addresses, :province
    add_index :refinery_marketing_addresses, :locale
  end
end
