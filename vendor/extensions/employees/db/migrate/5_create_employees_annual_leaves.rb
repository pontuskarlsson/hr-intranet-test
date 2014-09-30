class CreateEmployeesAnnualLeaves < ActiveRecord::Migration

  def up
    create_table :refinery_annual_leaves do |t|
      t.integer :employee_id
      t.integer :event_id
      t.date :start_date
      t.boolean :start_half_day,      null: false, default: 0
      t.date :end_date
      t.boolean :end_half_day,        null: false, default: 0
      t.decimal :number_of_days,      null: false, default: 0, scale: 2, precision: 10

      t.timestamps
    end

    add_index :refinery_annual_leaves, :employee_id
    add_index :refinery_annual_leaves, :event_id
    add_index :refinery_annual_leaves, :start_date
    add_index :refinery_annual_leaves, :end_date
  end

  def down
    remove_index :refinery_annual_leaves, :employee_id
    remove_index :refinery_annual_leaves, :event_id
    remove_index :refinery_annual_leaves, :start_date
    remove_index :refinery_annual_leaves, :end_date

    drop_table :refinery_annual_leaves

  end

end
