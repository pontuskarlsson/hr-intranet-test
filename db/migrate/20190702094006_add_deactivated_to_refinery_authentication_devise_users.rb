class AddDeactivatedToRefineryAuthenticationDeviseUsers < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :deactivated, :boolean, null: false, default: false
    add_column :refinery_authentication_devise_users, :first_name, :string
    add_column :refinery_authentication_devise_users, :last_name, :string
    add_column :refinery_authentication_devise_users, :timezone, :string
  end
end
