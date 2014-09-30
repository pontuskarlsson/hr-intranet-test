# This migration comes from refinery_employees (originally 3)
class CreateEmployeesEmploymentContracts < ActiveRecord::Migration

  def up
    create_table :refinery_employment_contracts do |t|
      t.integer :employee_id,             null: false
      t.date :start_date,                 null: false
      t.date :end_date
      t.decimal :vacation_days_per_year,  null: false, default: 0
      t.decimal :days_carried_over,       null: false, default: 0, scale: 2, precision: 10
      t.string :country

      t.timestamps
    end

    add_index :refinery_employment_contracts, :employee_id
    add_index :refinery_employment_contracts, :start_date
    add_index :refinery_employment_contracts, :end_date
  end

  def down
    remove_index :refinery_employment_contracts, :employee_id
    remove_index :refinery_employment_contracts, :start_date
    remove_index :refinery_employment_contracts, :end_date

    drop_table :refinery_employment_contracts

  end

end
