class CreateOmniAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :omni_authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.text :token
      t.integer :token_expires
      t.string :refresh_token
      t.text :auth_info
      t.text :extra

      t.timestamps
    end
    add_index :omni_authentications, :user_id
    add_index :omni_authentications, :provider
    add_index :omni_authentications, :uid
  end
end
