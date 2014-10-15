# This migration comes from refinery_employees (originally 13)
class AddInactiveColumnsToXeroModels < ActiveRecord::Migration

  def change
    add_column :refinery_xero_accounts, :inactive, :boolean,  null: false, default: 0
    add_column :refinery_xero_contacts, :inactive, :boolean,  null: false, default: 0

    add_index :refinery_xero_accounts, :inactive
    add_index :refinery_xero_contacts, :inactive
  end

end
