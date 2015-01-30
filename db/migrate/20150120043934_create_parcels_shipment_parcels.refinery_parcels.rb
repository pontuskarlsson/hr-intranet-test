# This migration comes from refinery_parcels (originally 5)
class CreateParcelsShipmentParcels < ActiveRecord::Migration

  def change
    create_table :refinery_parcels_shipment_parcels do |t|
      t.integer :shipment_id

      t.integer :length
      t.integer :width
      t.integer :height
      t.integer :weight
      t.string :predefined_package

      t.integer :position

      t.timestamps
    end

    add_index :refinery_parcels_shipment_parcels, :position
  end

end
