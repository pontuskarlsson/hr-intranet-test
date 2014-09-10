class CreateExpenseClaims < ActiveRecord::Migration
  def change
    create_table :expense_claims do |t|
      t.references :user,         null: false
      t.string :guid,             null: false, default: ''
      t.string :status,           null: false, default: 'Not-Submitted'
      t.string :description,      null: false, default: ''
      t.decimal :total,           null: false, default: 0
      t.decimal :amount_due,      null: false, default: 0
      t.decimal :amount_paid,     null: false, default: 0
      t.date :payment_due_date
      t.datetime :updated_date

      t.timestamps
    end
    add_index :expense_claims, :user_id
    add_index :expense_claims, :guid
    add_index :expense_claims, :status
  end
end
