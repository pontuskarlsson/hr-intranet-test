# This migration comes from refinery_parcels (originally 4)
class CreateParcelsShipmentAddresses < ActiveRecord::Migration

  def change
    create_table :refinery_parcels_shipment_addresses do |t|
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

    add_index :refinery_parcels_shipment_addresses, :position
    add_index :refinery_parcels_shipment_addresses, :easy_post_id
  end

end
