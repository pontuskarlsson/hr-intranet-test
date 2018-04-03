# This migration comes from refinery_marketing (originally 8)
class AddInsightlyAttributesToContact < ActiveRecord::Migration

  def change
    add_column :refinery_contacts, :insightly_id, :integer
    add_index :refinery_contacts, :insightly_id

    add_column :refinery_contacts, :courier_company, :string
    add_index :refinery_contacts, :courier_company

    add_column :refinery_contacts, :courier_account_no, :string
    add_column :refinery_contacts, :image_url, :string
  end

end
