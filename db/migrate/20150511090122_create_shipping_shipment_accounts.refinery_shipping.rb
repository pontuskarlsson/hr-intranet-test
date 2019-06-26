# This migration comes from refinery_shipping (originally 7)
class CreateShippingShipmentAccounts < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_shipment_accounts do |t|
      t.integer :contact_id
      t.string :description
      t.string :courier
      t.string :account_no
      t.text :comments

      t.integer :position

      t.timestamps
    end

    add_index :refinery_shipping_shipment_accounts, :contact_id
    add_index :refinery_shipping_shipment_accounts, :courier
    add_index :refinery_shipping_shipment_accounts, :account_no
    add_index :refinery_shipping_shipment_accounts, :position
  end

end
