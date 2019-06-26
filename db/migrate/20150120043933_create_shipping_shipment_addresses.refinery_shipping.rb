# This migration comes from refinery_shipping (originally 4)
class CreateShippingShipmentAddresses < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_shipment_addresses do |t|
      t.string :easy_post_id

      t.string :name
      t.string :company
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone
      t.string :email

      t.integer :position

      t.timestamps
    end

    add_index :refinery_shipping_shipment_addresses, :position, name: 'index_shipping_sa_on_position'
    add_index :refinery_shipping_shipment_addresses, :easy_post_id, name: 'index_shipping_sa_on_easy_post_id'
  end

end
