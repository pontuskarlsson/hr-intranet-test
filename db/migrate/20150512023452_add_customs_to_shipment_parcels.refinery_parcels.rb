# This migration comes from refinery_parcels (originally 9)
class AddCustomsToShipmentParcels < ActiveRecord::Migration

  def up
    add_column :refinery_parcels_shipment_parcels, :description, :string
    add_column :refinery_parcels_shipment_parcels, :quantity, :integer, null: false, default: 0
    add_column :refinery_parcels_shipment_parcels, :value, :decimal, precision: 8, scale: 2
    add_column :refinery_parcels_shipment_parcels, :origin_country, :string
    add_column :refinery_parcels_shipment_parcels, :contents_type, :string
  end

  def down
    remove_column :refinery_parcels_shipment_parcels, :description
    remove_column :refinery_parcels_shipment_parcels, :quantity
    remove_column :refinery_parcels_shipment_parcels, :value
    remove_column :refinery_parcels_shipment_parcels, :origin_country
    remove_column :refinery_parcels_shipment_parcels, :contents_type
  end

end
