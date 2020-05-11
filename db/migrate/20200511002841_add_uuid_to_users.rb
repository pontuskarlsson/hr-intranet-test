class AddUuidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :refinery_authentication_devise_users, :uuid, :uuid, default: 'gen_random_uuid()'
    add_index :refinery_authentication_devise_users, :uuid
  end
end
