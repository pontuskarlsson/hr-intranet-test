class CreateEmployeesSickLeaves < ActiveRecord::Migration

  def up
    create_table :refinery_sick_leaves do |t|
      t.integer :employee_id
      t.integer :event_id
      t.integer :doctors_note_id
      t.date :start_date
      t.boolean :start_half_day,      null: false, default: 0
      t.date :end_date
      t.boolean :end_half_day,        null: false, default: 0
      t.decimal :number_of_days,      null: false, default: 0

      t.timestamps
    end

    add_index :refinery_sick_leaves, :employee_id
    add_index :refinery_sick_leaves, :event_id
    add_index :refinery_sick_leaves, :doctors_note_id
    add_index :refinery_sick_leaves, :start_date
    add_index :refinery_sick_leaves, :end_date
  end

  def down
    remove_index :refinery_sick_leaves, :employee_id
    remove_index :refinery_sick_leaves, :event_id
    remove_index :refinery_sick_leaves, :doctors_note_id
    remove_index :refinery_sick_leaves, :start_date
    remove_index :refinery_sick_leaves, :end_date

    drop_table :refinery_sick_leaves

  end

end
