class CreateStoreOrderItems < ActiveRecord::Migration

  def change
    create_table :refinery_store_order_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.string :product_number
      t.decimal :quantity,            null: false, default: 0, scale: 2, precision: 10
      t.decimal :price_per_item,      null: false, default: 0, scale: 2, precision: 10
      t.decimal :sub_total_price,     null: false, default: 0, scale: 2, precision: 10
      t.string :comment

      t.integer :position

      t.timestamps
    end

    add_index :refinery_store_order_items, :order_id
    add_index :refinery_store_order_items, :product_id
    add_index :refinery_store_order_items, :product_number
    add_index :refinery_store_order_items, :position
  end

end
