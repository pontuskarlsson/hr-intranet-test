class CreateEmployeesXeroLineItems < ActiveRecord::Migration

  def up
    create_table :refinery_xero_line_items do |t|
      t.integer :xero_receipt_id
      t.integer :xero_account_id
      t.string :item_code
      t.string :description
      t.decimal :quantity,          null: false, default: 0, scale: 2, precision: 10
      t.decimal :unit_amount,       null: false, default: 0, scale: 2, precision: 10
      t.string :account_code
      t.string :tax_type
      t.decimal :tax_amount,        null: false, default: 0, scale: 2, precision: 10
      t.decimal :line_amount,       null: false, default: 0, scale: 2, precision: 10
      t.decimal :discount_rate,     null: false, default: 0, scale: 2, precision: 10

      t.timestamps
    end

    add_index :refinery_xero_line_items, :xero_receipt_id
    add_index :refinery_xero_line_items, :xero_account_id
  end

  def down
    remove_index :refinery_xero_line_items, :xero_receipt_id
    remove_index :refinery_xero_line_items, :xero_account_id

    drop_table :refinery_xero_line_items

  end

end
