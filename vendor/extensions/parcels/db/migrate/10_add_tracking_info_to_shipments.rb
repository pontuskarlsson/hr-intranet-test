class AddTrackingInfoToShipments < ActiveRecord::Migration

  def up
    add_column :refinery_parcels_shipments, :tracking_info, :text
  end

  def down
    remove_column :refinery_parcels_shipments, :tracking_info
  end

end
