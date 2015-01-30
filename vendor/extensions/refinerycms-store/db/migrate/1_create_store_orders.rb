class CreateStoreOrders < ActiveRecord::Migration

  def up
    create_table :refinery_store_orders do |t|
      t.integer :retailer_id
      t.string :order_number
      t.string :reference
      t.decimal :total_price,           null: false, default: 0, scale: 2, precision: 10
      t.string :price_unit
      t.integer :user_id
      t.string :status
      t.integer :position

      t.timestamps
    end

    add_index :refinery_store_orders, :retailer_id
    add_index :refinery_store_orders, :order_number
    add_index :refinery_store_orders, :user_id
    add_index :refinery_store_orders, :status
    add_index :refinery_store_orders, :position

  end

  def down
    remove_index :refinery_store_orders, :retailer_id
    remove_index :refinery_store_orders, :order_number
    remove_index :refinery_store_orders, :user_id
    remove_index :refinery_store_orders, :status
    remove_index :refinery_store_orders, :position

    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-store"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/store/orders"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/store/cart"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/store"})
    end

    drop_table :refinery_store_orders

  end

end
