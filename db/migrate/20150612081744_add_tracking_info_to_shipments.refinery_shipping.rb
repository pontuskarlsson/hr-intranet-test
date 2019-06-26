# This migration comes from refinery_shipping (originally 10)
class AddTrackingInfoToShipments < ActiveRecord::Migration

  def up
    add_column :refinery_shipping_shipments, :tracking_info, :text
  end

  def down
    remove_column :refinery_shipping_shipments, :tracking_info
  end

end
