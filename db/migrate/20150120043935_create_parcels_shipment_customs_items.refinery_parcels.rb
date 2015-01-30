# This migration comes from refinery_parcels (originally 6)
class CreateParcelsShipmentCustomsItems < ActiveRecord::Migration

  def change
    create_table :refinery_parcels_shipment_customs_items do |t|
      t.integer :shipment_id
      t.string :description
      t.integer :quantity
      t.integer :value
      t.integer :weight
      t.integer :hs_tariff_number
      t.string :origin_country

      t.integer :position

      t.timestamps
    end

    add_index :refinery_parcels_shipment_customs_items, :position
  end

end
