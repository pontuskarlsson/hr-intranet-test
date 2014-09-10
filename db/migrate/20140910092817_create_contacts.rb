class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :guid,       null: false, default: ''
      t.string :name,       null: false, default: ''

      t.timestamps
    end
    add_index :contacts, :guid
    add_index :contacts, :name
  end
end
