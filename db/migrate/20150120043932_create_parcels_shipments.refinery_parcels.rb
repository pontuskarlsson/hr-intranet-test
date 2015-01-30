# This migration comes from refinery_parcels (originally 3)
class CreateParcelsShipments < ActiveRecord::Migration

  def change
    create_table :refinery_parcels_shipments do |t|
      t.integer :from_contact_id
      t.integer :from_address_id
      t.integer :to_contact_id
      t.integer :to_address_id
      t.integer :created_by_id
      t.integer :assigned_to_id

      t.string :courier

      t.string :eel_pfc
      t.boolean :customs_certify
      t.string :customs_signer
      t.string :contents_type
      t.string :contents_explanation

      t.integer :position

      t.timestamps
    end

    add_index :refinery_parcels_shipments, :position
    add_index :refinery_parcels_shipments, :from_contact_id
    add_index :refinery_parcels_shipments, :from_address_id
    add_index :refinery_parcels_shipments, :to_contact_id
    add_index :refinery_parcels_shipments, :to_address_id
    add_index :refinery_parcels_shipments, :created_by_id
    add_index :refinery_parcels_shipments, :assigned_to_id
  end

end
