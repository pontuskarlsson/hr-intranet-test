class CreateAnotherBusinessOrderItems < ActiveRecord::Migration

  def change
    create_table :refinery_business_order_items do |t|
      t.integer  :order_id
      t.string   :order_item_id
      t.integer  :line_item_number

      t.integer  :article_id
      t.string   :article_code
      t.string   :description

      t.decimal  :ordered_qty, null: false, default: 0, precision: 13, scale: 4
      t.decimal  :shipped_qty, precision: 13, scale: 4
      t.string   :qty_unit
      t.decimal  :unit_price, null: false, default: 0, precision: 13, scale: 4
      t.decimal  :discount, null: false, default: 0, precision: 12, scale: 6
      t.decimal  :total_cost, null: false, default: 0, precision: 13, scale: 4

      t.string   :account

      t.timestamps
    end

    add_index :refinery_business_order_items, :order_id
    add_index :refinery_business_order_items, :order_item_id
    add_index :refinery_business_order_items, :line_item_number
    add_index :refinery_business_order_items, :article_id
    add_index :refinery_business_order_items, :article_code
    add_index :refinery_business_order_items, :ordered_qty
    add_index :refinery_business_order_items, :shipped_qty
    add_index :refinery_business_order_items, :qty_unit
    add_index :refinery_business_order_items, :unit_price
    add_index :refinery_business_order_items, :total_cost
    add_index :refinery_business_order_items, :account
  end

end
