class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.references :user,       null: false
      t.references :event
      t.datetime :starts_at,    null: false
      t.datetime :ends_at,      null: false
      t.string :comment,        null: false, default: ''
      t.boolean :approved,      null: false, default: 0

      t.timestamps
    end
    add_index :leaves, :user_id
    add_index :leaves, :event_id
    add_index :leaves, :starts_at
    add_index :leaves, :ends_at
    add_index :leaves, :approved
  end
end
