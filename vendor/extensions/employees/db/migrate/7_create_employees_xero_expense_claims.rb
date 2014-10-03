class CreateEmployeesXeroExpenseClaims < ActiveRecord::Migration

  def up
    create_table :refinery_xero_expense_claims do |t|
      t.integer :employee_id
      t.string :description
      t.string :guid
      t.string :status
      t.decimal :total,             null: false, default: 0, scale: 2, precision: 10
      t.decimal :amount_due,        null: false, default: 0, scale: 2, precision: 10
      t.decimal :amount_paid,       null: false, default: 0, scale: 2, precision: 10
      t.date :payment_due_date
      t.date :reporting_date
      t.datetime :updated_date_utc

      t.timestamps
    end

    add_index :refinery_xero_expense_claims, :employee_id
    add_index :refinery_xero_expense_claims, :guid
    add_index :refinery_xero_expense_claims, :updated_date_utc
  end

  def down
    remove_index :refinery_xero_expense_claims, :employee_id
    remove_index :refinery_xero_expense_claims, :guid
    remove_index :refinery_xero_expense_claims, :updated_date_utc

    drop_table :refinery_xero_expense_claims

  end

end
