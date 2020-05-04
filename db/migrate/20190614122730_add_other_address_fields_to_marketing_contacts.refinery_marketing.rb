# This migration comes from refinery_marketing (originally 12)
class AddOtherAddressFieldsToMarketingContacts < ActiveRecord::Migration

  def change
    add_column :refinery_contacts, :other_address, :string
    add_column :refinery_contacts, :other_city, :string
    add_column :refinery_contacts, :other_zip, :string
    add_column :refinery_contacts, :other_state, :string
    add_column :refinery_contacts, :other_country, :string

    add_column :refinery_contacts, :image_id, :integer
    add_index :refinery_contacts, :image_id

    add_column :refinery_contacts, :owner_id, :integer
    add_index :refinery_contacts, :owner_id

    add_column :refinery_contacts, :br_number, :string
    add_index :refinery_contacts, :br_number
  end

end
