# This migration comes from refinery_shipping (originally 11)
class AddCodeToShipments < ActiveRecord::Migration

  def change
    change_column :refinery_shipping_shipments, :rate_amount, :decimal, precision: 13, scale: 4

    add_column :refinery_shipping_shipments, :project_id, :integer
    add_index :refinery_shipping_shipments, :project_id

    add_column :refinery_shipping_shipments, :code, :string
    add_index :refinery_shipping_shipments, :code

    add_column :refinery_shipping_shipments, :to_company_id, :integer
    add_index :refinery_shipping_shipments, :to_company_id

    add_column :refinery_shipping_shipments, :from_company_id, :integer
    add_index :refinery_shipping_shipments, :from_company_id

    add_column :refinery_shipping_shipments, :consignee_company_id, :integer
    add_index :refinery_shipping_shipments, :consignee_company_id

    add_column :refinery_shipping_shipments, :consignee_address_id, :integer
    add_index :refinery_shipping_shipments, :consignee_address_id

    add_column :refinery_shipping_shipments, :consignee_reference, :string
    add_index :refinery_shipping_shipments, :consignee_reference

    add_column :refinery_shipping_shipments, :mode, :string
    add_index :refinery_shipping_shipments, :mode

    add_column :refinery_shipping_shipments, :forwarder, :string
    add_index :refinery_shipping_shipments, :forwarder

    add_column :refinery_shipping_shipments, :forwarder_booking_number, :string
    add_index :refinery_shipping_shipments, :forwarder_booking_number

    add_column :refinery_shipping_shipments, :comments, :string
    add_index :refinery_shipping_shipments, :comments

    add_column :refinery_shipping_shipments, :no_of_parcels, :integer
    add_index :refinery_shipping_shipments, :no_of_parcels

    add_column :refinery_shipping_shipments, :duty_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :terminal_fee_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :domestic_transportation_cost_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :forwarding_fee_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :freight_cost_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :volume_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :volume_manual_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :volume_unit, :string
    add_column :refinery_shipping_shipments, :gross_weight_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :gross_weight_manual_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :net_weight_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :net_weight_manual_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :chargeable_weight_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :chargeable_weight_manual_amount, :decimal, precision: 13, scale: 4
    add_column :refinery_shipping_shipments, :weight_unit, :string
  end

end
