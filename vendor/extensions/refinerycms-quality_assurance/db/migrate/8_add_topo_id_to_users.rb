class AddTopoIdToUsers < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :topo_id, :string
    add_index :refinery_authentication_devise_users, :topo_id
  end
end
