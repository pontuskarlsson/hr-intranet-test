# This migration comes from refinery_shipping (originally 14)
class AddTermsToShipments < ActiveRecord::Migration

  def change
    add_column :refinery_shipping_shipments, :shipment_terms, :string
    add_index :refinery_shipping_shipments, :shipment_terms

    add_column :refinery_shipping_shipments, :shipment_terms_details, :text

    add_column :refinery_shipping_shipments, :archived_at, :datetime
    add_index :refinery_shipping_shipments, :archived_at

    add_column :refinery_shipping_shipments, :length_unit, :string

    add_column :refinery_shipping_shipments, :cargo_ready_date, :date
    add_index :refinery_shipping_shipments, :cargo_ready_date

    add_column :refinery_shipping_shipments, :no_of_parcels_manual, :integer
    add_index :refinery_shipping_shipments, :no_of_parcels_manual

  end

end
