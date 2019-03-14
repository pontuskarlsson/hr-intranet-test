class RenamePasswordChangedAtIndex < ActiveRecord::Migration
  def change
    remove_index :refinery_users, :password_changed_at
    add_index :refinery_users, :password_changed_at, name: :refinery_devise_users_password_changed_at
  end
end
