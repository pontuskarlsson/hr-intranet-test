# This migration comes from refinery_employees (originally 6)
class CreateEmployeesAnnualLeaveRecords < ActiveRecord::Migration

  def up
    create_table :refinery_annual_leave_records do |t|
      t.integer :employee_id
      t.integer :annual_leave_id
      t.string :record_type
      t.date :record_date
      t.decimal :record_value,      null: false, default: 0, scale: 2, precision: 10

      t.timestamps
    end

    add_index :refinery_annual_leave_records, :employee_id
    add_index :refinery_annual_leave_records, :annual_leave_id
    add_index :refinery_annual_leave_records, :record_type
    add_index :refinery_annual_leave_records, :record_date
  end

  def down
    remove_index :refinery_annual_leave_records, :employee_id
    remove_index :refinery_annual_leave_records, :annual_leave_id
    remove_index :refinery_annual_leave_records, :record_type
    remove_index :refinery_annual_leave_records, :record_date

    drop_table :refinery_annual_leave_records

  end

end
