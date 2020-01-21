# This migration comes from refinery_shipping (originally 20)
class CreateShippingCosts < ActiveRecord::Migration[5.0]

  def change
    create_table :refinery_shipping_costs do |t|
      t.integer :shipment_id

      t.string :cost_type
      t.text :comments

      t.string :currency_code
      t.decimal :amount, precision: 13, scale: 4
      t.decimal :invoice_amount, precision: 13, scale: 4

      t.timestamps
    end

    add_index :refinery_shipping_costs, :shipment_id
    add_index :refinery_shipping_costs, :cost_type
    add_index :refinery_shipping_costs, :currency_code
    add_index :refinery_shipping_costs, :amount
    add_index :refinery_shipping_costs, :invoice_amount
  end

end
