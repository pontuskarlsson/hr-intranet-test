class CreateStoreProducts < ActiveRecord::Migration

  def change
    create_table :refinery_store_products do |t|
      t.integer :retailer_id
      t.string :product_number
      t.string :name
      t.text :description
      t.string :measurement_unit
      t.decimal :price_amount,        null: false, default: 0, scale: 2, precision: 10
      t.string :price_unit
      t.integer :image_id
      t.date :featured_at
      t.date :expired_at

      t.integer :position

      t.timestamps
    end

    add_index :refinery_store_products, :retailer_id
    add_index :refinery_store_products, :product_number
    add_index :refinery_store_products, :image_id
    add_index :refinery_store_products, :position
    add_index :refinery_store_products, :featured_at
    add_index :refinery_store_products, :expired_at
  end

end
