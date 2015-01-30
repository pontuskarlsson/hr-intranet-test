class CreateEmployeesXeroReceipts < ActiveRecord::Migration

  def up
    create_table :refinery_xero_receipts do |t|
      t.integer :employee_id
      t.integer :xero_expense_claim_id
      t.integer :xero_contact_id
      t.string :guid
      t.string :receipt_number
      t.string :reference
      t.string :status
      t.string :line_amount_types
      t.decimal :sub_total,       null: false, default: 0, scale: 2, precision: 10
      t.decimal :total_tax,       null: false, default: 0, scale: 2, precision: 10
      t.decimal :total,           null: false, default: 0, scale: 2, precision: 10
      t.date :date
      t.string :url
      t.boolean :has_attachments, null: false, default: 0
      t.datetime :updated_date_utc

      t.timestamps
    end

    add_index :refinery_xero_receipts, :employee_id
    add_index :refinery_xero_receipts, :xero_expense_claim_id
    add_index :refinery_xero_receipts, :xero_contact_id
    add_index :refinery_xero_receipts, :guid
    add_index :refinery_xero_receipts, :updated_date_utc
  end

  def down
    remove_index :refinery_xero_receipts, :employee_id
    remove_index :refinery_xero_receipts, :xero_expense_claim_id
    remove_index :refinery_xero_receipts, :xero_contact_id
    remove_index :refinery_xero_receipts, :guid
    remove_index :refinery_xero_receipts, :updated_date_utc

    drop_table :refinery_xero_receipts

  end

end
