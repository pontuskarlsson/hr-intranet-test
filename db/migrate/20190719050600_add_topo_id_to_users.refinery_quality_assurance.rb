# This migration comes from refinery_quality_assurance (originally 8)
class AddTopoIdToUsers < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :topo_id, :string
    add_index :refinery_authentication_devise_users, :topo_id
  end
end
