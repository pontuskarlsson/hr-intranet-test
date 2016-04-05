class CreateEmployeesLeaveOfAbsences < ActiveRecord::Migration

  def up
    create_table :refinery_leave_of_absences do |t|
      t.integer :employee_id
      t.integer :event_id
      t.integer :doctors_note_id
      t.integer :absence_type_id
      t.string :absence_type_description
      t.integer :status
      t.date :start_date
      t.boolean :start_half_day,      null: false, default: 0
      t.date :end_date
      t.boolean :end_half_day,        null: false, default: 0

      t.timestamps
    end

    add_index :refinery_leave_of_absences, :employee_id
    add_index :refinery_leave_of_absences, :event_id
    add_index :refinery_leave_of_absences, :doctors_note_id
    add_index :refinery_leave_of_absences, :absence_type_id
    add_index :refinery_leave_of_absences, :status
    add_index :refinery_leave_of_absences, :start_date
    add_index :refinery_leave_of_absences, :end_date
  end

  def down
    remove_index :refinery_leave_of_absences, :employee_id
    remove_index :refinery_leave_of_absences, :event_id
    remove_index :refinery_leave_of_absences, :doctors_note_id
    remove_index :refinery_leave_of_absences, :absence_type_id
    remove_index :refinery_leave_of_absences, :status
    remove_index :refinery_leave_of_absences, :start_date
    remove_index :refinery_leave_of_absences, :end_date

    drop_table :refinery_leave_of_absences

  end

end
