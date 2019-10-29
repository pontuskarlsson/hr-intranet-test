# This migration comes from refinery_business (originally 25)
class CreateBusinessInvoiceItems < ActiveRecord::Migration

  def change
    create_table :refinery_business_invoice_items do |t|
      t.integer :invoice_id
      t.string :line_item_id

      t.string :description
      t.decimal :quantity, precision: 13, scale: 4
      t.decimal :unit_amount, precision: 13, scale: 4
      t.string :item_code
      t.string :account_code
      t.string :tax_type
      t.decimal :tax_amount, precision: 13, scale: 4
      t.decimal :line_amount, precision: 13, scale: 4

      t.integer :billable_id
      t.string :transaction_type

      t.integer :line_item_order

      t.timestamps
    end

    add_index :refinery_business_invoice_items, :invoice_id, name: 'INDEX_rb_invoice_items_ON_invoice_id'
    add_index :refinery_business_invoice_items, :line_item_id, name: 'INDEX_rb_invoice_items_ON_line_item_id'
    add_index :refinery_business_invoice_items, :description, name: 'INDEX_rb_invoice_items_ON_description'
    add_index :refinery_business_invoice_items, :item_code, name: 'INDEX_rb_invoice_items_ON_item_code'
    add_index :refinery_business_invoice_items, :account_code, name: 'INDEX_rb_invoice_items_ON_account_code'
    add_index :refinery_business_invoice_items, :tax_type, name: 'INDEX_rb_invoice_items_ON_tax_type'
    add_index :refinery_business_invoice_items, :billable_id, name: 'INDEX_rb_invoice_items_ON_billable_id'
    add_index :refinery_business_invoice_items, :transaction_type, name: 'INDEX_rb_invoice_items_ON_transaction_type'
    add_index :refinery_business_invoice_items, :line_item_order, name: 'INDEX_rb_invoice_items_ON_line_item_order'
  end

end
