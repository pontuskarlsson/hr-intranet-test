class AddFullNameToRefineryUser < ActiveRecord::Migration
  def change
    add_column :refinery_users, :full_name, :string
    add_index :refinery_users, :full_name
  end
end
