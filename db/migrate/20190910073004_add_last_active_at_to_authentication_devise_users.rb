class AddLastActiveAtToAuthenticationDeviseUsers < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :last_active_at, :datetime
    add_index :refinery_authentication_devise_users, :last_active_at
  end
end
