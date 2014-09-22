class CreateSalesOrdersOrderItems < ActiveRecord::Migration

  def up
    create_table :refinery_order_items do |t|
      t.integer :sales_order_id,    null: false

      t.string :order_detail_id, null: false, default: ''
      t.string :order_detail_imported_ref, null: false, default: ''
      t.string :order_id, null: false, default: ''
      t.string :order_ref, null: false, default: ''
      t.datetime :created_date
      t.boolean :active, null: false, default: 0
      t.string :sku, null: false, default: ''
      t.string :code, null: false, default: ''
      t.string :product_id, null: false, default: ''
      t.string :style_code, null: false, default: ''
      t.string :master_id, null: false, default: ''
      t.decimal :price, null: false, default: 0
      t.decimal :qty, null: false, default: 0
      t.string :name, null: false, default: ''
      t.decimal :discount, null: false, default: 0
      t.string :option1, null: false, default: ''
      t.string :option2, null: false, default: ''
      t.string :option3, null: false, default: ''
      t.string :line_comments, null: false, default: ''

      t.integer :position
      t.timestamps
    end

    add_index :refinery_order_items, :sales_order_id
    add_index :refinery_order_items, :order_detail_id
    add_index :refinery_order_items, :order_id
    add_index :refinery_order_items, :active
    add_index :refinery_order_items, :position
  end

  def down
    remove_index :refinery_order_items, :sales_order_id
    remove_index :refinery_order_items, :order_detail_id
    remove_index :refinery_order_items, :order_id
    remove_index :refinery_order_items, :active
    remove_index :refinery_order_items, :position

    drop_table :refinery_order_items

  end

end
