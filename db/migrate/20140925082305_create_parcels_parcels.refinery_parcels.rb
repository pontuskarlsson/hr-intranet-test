# This migration comes from refinery_parcels (originally 1)
class CreateParcelsParcels < ActiveRecord::Migration

  def up
    create_table :refinery_parcels do |t|
      t.date :parcel_date
      t.string :from_name
      t.integer :from_contact_id
      t.string :courier
      t.string :air_waybill_no
      t.string :to_name
      t.integer :to_user_id
      t.integer :shipping_document_id
      t.boolean :receiver_signed,    null: false, default: 0

      t.integer :position

      t.timestamps
    end

    add_index :refinery_parcels, :position
    add_index :refinery_parcels, :from_contact_id
    add_index :refinery_parcels, :to_user_id
    add_index :refinery_parcels, :shipping_document_id
    add_index :refinery_parcels, :receiver_signed
  end

  def down
    remove_index :refinery_parcels, :position
    remove_index :refinery_parcels, :from_contact_id
    remove_index :refinery_parcels, :to_user_id
    remove_index :refinery_parcels, :shipping_document_id
    remove_index :refinery_parcels, :receiver_signed

    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-parcels"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/parcels/parcels"})
    end

    drop_table :refinery_parcels

  end

end
