class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :guid,     null: false, default: ''
      t.string :code,     null: false, default: ''
      t.string :name,     null: false, default: ''

      t.timestamps
    end
    add_index :accounts, :guid
    add_index :accounts, :code
  end
end
