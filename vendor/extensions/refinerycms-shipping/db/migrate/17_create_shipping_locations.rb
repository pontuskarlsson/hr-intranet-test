class CreateShippingLocations < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_locations do |t|
      t.string :name
      t.text :description

      t.integer :owner_id
      t.string :location_type

      t.boolean :airport, null: false, default: false
      t.boolean :railport, null: false, default: false
      t.boolean :roadport, null: false, default: false
      t.boolean :seaport, null: false, default: false

      t.string :location_code
      t.string :iata_code
      t.string :icao_code

      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :country_code
      t.string :timezone
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lng, precision: 9, scale: 6

      t.string :customs_district_code

      t.datetime :confirmed_at
      t.datetime :verified_at
      t.datetime :archived_at

      t.boolean :public, null: false, default: false

      t.timestamps
    end

    add_index :refinery_shipping_locations, :name
    add_index :refinery_shipping_locations, :owner_id
    add_index :refinery_shipping_locations, :location_type
    add_index :refinery_shipping_locations, :airport
    add_index :refinery_shipping_locations, :railport
    add_index :refinery_shipping_locations, :roadport
    add_index :refinery_shipping_locations, :seaport
    add_index :refinery_shipping_locations, :location_code
    add_index :refinery_shipping_locations, :iata_code
    add_index :refinery_shipping_locations, :icao_code
    add_index :refinery_shipping_locations, :street1
    add_index :refinery_shipping_locations, :street2
    add_index :refinery_shipping_locations, :city
    add_index :refinery_shipping_locations, :state
    add_index :refinery_shipping_locations, :postal_code
    add_index :refinery_shipping_locations, :country
    add_index :refinery_shipping_locations, :country_code
    add_index :refinery_shipping_locations, :timezone
    add_index :refinery_shipping_locations, :lat
    add_index :refinery_shipping_locations, :lng
    add_index :refinery_shipping_locations, :customs_district_code
    add_index :refinery_shipping_locations, :confirmed_at
    add_index :refinery_shipping_locations, :verified_at
    add_index :refinery_shipping_locations, :archived_at
    add_index :refinery_shipping_locations, :public
  end

end
