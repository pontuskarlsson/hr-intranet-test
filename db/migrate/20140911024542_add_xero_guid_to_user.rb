class AddXeroGuidToUser < ActiveRecord::Migration
  def change
    add_column :refinery_users, :xero_guid, :string, null: false, default: ''
  end
end
