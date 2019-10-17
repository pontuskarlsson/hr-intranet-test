class CreateShippingRoutes < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_routes do |t|
      t.integer :shipment_id
      t.integer :location_id

      t.string :route_type
      t.string :route_description
      t.text :notes
      t.string :status

      t.datetime :arrived_at
      t.datetime :departed_at

      t.integer :prior_route_id
      t.boolean :final_destination, null: false, default: false

      t.timestamps
    end

    add_index :refinery_shipping_routes, :shipment_id
    add_index :refinery_shipping_routes, :location_id
    add_index :refinery_shipping_routes, :route_type
    add_index :refinery_shipping_routes, :route_description
    add_index :refinery_shipping_routes, :status
    add_index :refinery_shipping_routes, :arrived_at
    add_index :refinery_shipping_routes, :departed_at
    add_index :refinery_shipping_routes, :prior_route_id
    add_index :refinery_shipping_routes, :final_destination
  end

end
