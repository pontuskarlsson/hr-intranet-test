class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.references :user
      t.string :identifier
      t.text :content

      t.timestamps
    end
    add_index :user_settings, :user_id
    add_index :user_settings, :identifier
  end
end
