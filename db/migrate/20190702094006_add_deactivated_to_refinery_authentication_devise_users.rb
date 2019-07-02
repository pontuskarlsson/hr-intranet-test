class AddDeactivatedToRefineryAuthenticationDeviseUsers < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :deactivated, :boolean, null: false, default: false
  end
end
