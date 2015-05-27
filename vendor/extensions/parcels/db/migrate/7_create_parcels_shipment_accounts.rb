class CreateParcelsShipmentAccounts < ActiveRecord::Migration

  def change
    create_table :refinery_parcels_shipment_accounts do |t|
      t.integer :contact_id
      t.string :description
      t.string :courier
      t.string :account_no
      t.text :comments

      t.integer :position

      t.timestamps
    end

    add_index :refinery_parcels_shipment_accounts, :contact_id
    add_index :refinery_parcels_shipment_accounts, :courier
    add_index :refinery_parcels_shipment_accounts, :account_no
    add_index :refinery_parcels_shipment_accounts, :position
  end

end
