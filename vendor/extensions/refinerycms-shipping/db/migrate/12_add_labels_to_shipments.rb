class AddLabelsToShipments < ActiveRecord::Migration

  def change
    add_column :refinery_shipping_shipments, :from_contact_label, :string
    add_index :refinery_shipping_shipments, :from_contact_label

    add_column :refinery_shipping_shipments, :from_company_label, :string
    add_index :refinery_shipping_shipments, :from_company_label

    add_column :refinery_shipping_shipments, :to_contact_label, :string
    add_index :refinery_shipping_shipments, :to_contact_label

    add_column :refinery_shipping_shipments, :to_company_label, :string
    add_index :refinery_shipping_shipments, :to_company_label

    add_column :refinery_shipping_shipments, :consignee_company_label, :string
    add_index :refinery_shipping_shipments, :consignee_company_label

    add_column :refinery_shipping_shipments, :created_by_label, :string
    add_index :refinery_shipping_shipments, :created_by_label

    add_column :refinery_shipping_shipments, :assigned_to_label, :string
    add_index :refinery_shipping_shipments, :assigned_to_label
  end

end
