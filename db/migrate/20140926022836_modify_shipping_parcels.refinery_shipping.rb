# This migration comes from refinery_shipping (originally 2)
class ModifyShippingParcels < ActiveRecord::Migration

  def up
    add_column :refinery_shipping_parcels, :received_by_id, :integer
    add_column :refinery_shipping_parcels, :assigned_to_id, :integer
    add_column :refinery_shipping_parcels, :description, :string

    add_index :refinery_shipping_parcels, :received_by_id
    add_index :refinery_shipping_parcels, :assigned_to_id

  end

  def down
    remove_index :refinery_shipping_parcels, :received_by_id
    remove_index :refinery_shipping_parcels, :assigned_to_id

    remove_column :refinery_shipping_parcels, :received_by_id
    remove_column :refinery_shipping_parcels, :assigned_to_id
    remove_column :refinery_shipping_parcels, :description

  end

end
