class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :receipt,      null: false
      t.references :account,      null: false
      t.string :description,      null: false, default: ''
      t.string :item_code,        null: false, default: ''
      t.decimal :quantity,        null: false, default: 0
      t.decimal :unit_amount,     null: false, default: 0
      t.string :tax_type,         null: false, default: ''
      t.decimal :tax_amount,      null: false, default: 0
      t.decimal :line_amount,     null: false, default: 0
      t.decimal :discount_rate,   null: false, default: 0

      t.timestamps
    end
    add_index :line_items, :receipt_id
    add_index :line_items, :account_id
  end
end
