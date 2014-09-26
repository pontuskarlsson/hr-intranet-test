# This migration comes from refinery_parcels (originally 2)
class ModifyParcelsParcels < ActiveRecord::Migration

  def up
    add_column :refinery_parcels, :received_by_id, :integer
    add_column :refinery_parcels, :assigned_to_id, :integer
    add_column :refinery_parcels, :description, :string

    add_index :refinery_parcels, :received_by_id
    add_index :refinery_parcels, :assigned_to_id
  end

  def down
    remove_index :refinery_parcels, :received_by_id
    remove_index :refinery_parcels, :assigned_to_id

    remove_column :refinery_parcels, :received_by_id
    remove_column :refinery_parcels, :assigned_to_id
    remove_column :refinery_parcels, :description
  end

end
