# This migration comes from refinery_shipping (originally 13)
class AddDatesToShipments < ActiveRecord::Migration

  def change
    rename_column :refinery_shipping_shipments, :shipping_date, :etd_date
    add_column :refinery_shipping_shipments, :eta_date, :date
    add_index :refinery_shipping_shipments, :eta_date

    rename_column :refinery_shipping_shipments, :from_company_id, :shipper_company_id
    rename_column :refinery_shipping_shipments, :from_company_label, :shipper_company_label

    rename_column :refinery_shipping_shipments, :to_company_id, :receiver_company_id
    rename_column :refinery_shipping_shipments, :to_company_label, :receiver_company_label

    add_column :refinery_shipping_shipments, :supplier_company_id, :integer
    add_index :refinery_shipping_shipments, :supplier_company_id

    add_column :refinery_shipping_shipments, :supplier_company_label, :string
    add_index :refinery_shipping_shipments, :supplier_company_label

    add_column :refinery_shipping_shipments, :forwarder_company_id, :integer
    add_index :refinery_shipping_shipments, :forwarder_company_id

    rename_column :refinery_shipping_shipments, :forwarder, :forwarder_company_label

    add_column :refinery_shipping_shipments, :load_port, :string

    add_column :refinery_shipping_shipments, :courier_company_id, :integer
    add_index :refinery_shipping_shipments, :courier_company_id

    rename_column :refinery_shipping_shipments, :courier, :courier_company_label
  end

end
