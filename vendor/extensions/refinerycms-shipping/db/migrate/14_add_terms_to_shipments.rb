class AddTermsToShipments < ActiveRecord::Migration

  def change
    add_column :refinery_shipping_shipments, :shipment_terms, :string
    add_index :refinery_shipping_shipments, :shipment_terms

    add_column :refinery_shipping_shipments, :shipment_terms_details, :text
  end

end
