class AddFeaturedToXeroAccounts < ActiveRecord::Migration

  def change
    add_column :refinery_xero_accounts, :featured, :boolean,  null: false, default: 0
    add_column :refinery_xero_accounts, :when_to_use, :text

    add_index :refinery_xero_accounts, :featured
  end

end
