# This migration comes from refinery_marketing (originally 6)
class AddUserToMarketingContacts < ActiveRecord::Migration

  def change
    add_column :refinery_contacts, :user_id, :integer
    add_index :refinery_contacts, :user_id
  end

end
