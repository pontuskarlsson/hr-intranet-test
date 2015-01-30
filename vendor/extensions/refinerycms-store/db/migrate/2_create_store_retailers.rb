class CreateStoreRetailers < ActiveRecord::Migration

  def change
    create_table :refinery_store_retailers do |t|
      t.string :name
      t.string :default_price_unit
      t.integer :position
      t.date :expired_at

      t.timestamps
    end

    add_index :refinery_store_retailers, :name
    add_index :refinery_store_retailers, :expired_at
    add_index :refinery_store_retailers, :position

  end

end
