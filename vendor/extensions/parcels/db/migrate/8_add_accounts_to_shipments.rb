class AddAccountsToShipments < ActiveRecord::Migration

  def up
    add_column :refinery_parcels_shipments, :bill_to_account_id, :integer
    add_column :refinery_parcels_shipments, :bill_to, :string
    add_column :refinery_parcels_shipments, :description, :string
    add_column :refinery_parcels_shipments, :label_url, :string
    add_column :refinery_parcels_shipments, :tracking_number, :string
    add_column :refinery_parcels_shipments, :tracking_status, :string
    add_column :refinery_parcels_shipments, :status, :string
    add_column :refinery_parcels_shipments, :easypost_object_id, :string
    add_column :refinery_parcels_shipments, :rates_content, :text
    add_column :refinery_parcels_shipments, :rate_object_id, :string
    add_column :refinery_parcels_shipments, :rate_service, :string
    add_column :refinery_parcels_shipments, :rate_amount, :decimal, precision: 8, scale: 2
    add_column :refinery_parcels_shipments, :rate_currency, :string
    add_column :refinery_parcels_shipments, :shipping_date, :date

    add_index :refinery_parcels_shipments, :bill_to_account_id, name: 'index_refinery_parcels_shipments_on_bta_id'
    add_index :refinery_parcels_shipments, :status
    add_index :refinery_parcels_shipments, :easypost_object_id, name: 'index_refinery_parcels_shipments_on_eo_id'

    remove_column :refinery_parcels_shipments, :eel_pfc
    remove_column :refinery_parcels_shipments, :customs_certify
    remove_column :refinery_parcels_shipments, :customs_signer
    remove_column :refinery_parcels_shipments, :contents_type
    remove_column :refinery_parcels_shipments, :contents_explanation
  end

  def down
    add_column :refinery_parcels_shipments, :eel_pfc, :string
    add_column :refinery_parcels_shipments, :customs_certify, :boolean
    add_column :refinery_parcels_shipments, :customs_signer, :string
    add_column :refinery_parcels_shipments, :contents_type, :string
    add_column :refinery_parcels_shipments, :contents_explanation, :string

    remove_index :refinery_parcels_shipments, name: 'index_refinery_parcels_shipments_on_bta_id'
    remove_index :refinery_parcels_shipments, :status
    remove_index :refinery_parcels_shipments, name: 'index_refinery_parcels_shipments_on_eo_id'

    remove_column :refinery_parcels_shipments, :bill_to_account_id
    remove_column :refinery_parcels_shipments, :bill_to
    remove_column :refinery_parcels_shipments, :description
    remove_column :refinery_parcels_shipments, :label_url
    remove_column :refinery_parcels_shipments, :tracking_number
    remove_column :refinery_parcels_shipments, :tracking_status
    remove_column :refinery_parcels_shipments, :status
    remove_column :refinery_parcels_shipments, :easypost_object_id
    remove_column :refinery_parcels_shipments, :rates_content
    remove_column :refinery_parcels_shipments, :rate_object_id
    remove_column :refinery_parcels_shipments, :rate_service
    remove_column :refinery_parcels_shipments, :rate_amount
    remove_column :refinery_parcels_shipments, :rate_currency
    remove_column :refinery_parcels_shipments, :shipping_date
  end

end
