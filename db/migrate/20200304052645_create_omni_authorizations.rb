class CreateOmniAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :omni_authorizations do |t|
      t.integer :omni_authentication_id
      t.integer :company_id
      t.integer :account_id
      t.string :type
      t.text :content

      t.timestamps
    end
    add_index :omni_authorizations, :omni_authentication_id
    add_index :omni_authorizations, :company_id
    add_index :omni_authorizations, :account_id
    add_index :omni_authorizations, :type
  end
end
