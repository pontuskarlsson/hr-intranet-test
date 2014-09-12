class AddPasswordExpireableToRefineryUser < ActiveRecord::Migration
  def change
    add_column :refinery_users, :password_changed_at, :datetime
    add_index :refinery_users, :password_changed_at
  end
end
