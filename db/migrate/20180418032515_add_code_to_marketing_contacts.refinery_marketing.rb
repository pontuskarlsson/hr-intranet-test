# This migration comes from refinery_marketing (originally 9)
class AddCodeToMarketingContacts < ActiveRecord::Migration

  def change
    add_column :refinery_contacts, :code, :string
    add_index :refinery_contacts, :code
  end

end
