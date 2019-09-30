# This migration comes from refinery_business (originally 19)
class CreateBusinessOrders < ActiveRecord::Migration

  def change
    create_table :refinery_business_orders do |t|
      t.string   :order_id
      t.integer  :buyer_id
      t.string   :buyer_label
      t.integer  :seller_id
      t.string   :seller_label
      t.integer  :project_id

      t.string   :order_number
      t.string   :order_type
      t.date     :order_date
      t.integer  :version_number
      t.date     :revised_date
      t.string   :reference
      t.text     :description

      t.date     :delivery_date
      t.text     :delivery_address
      t.text     :delivery_instructions
      t.string   :ship_mode
      t.string   :shipment_terms
      t.string   :attention_to
      t.string   :status

      t.string   :proforma_invoice_label
      t.string   :invoice_label

      t.decimal  :ordered_qty, null: false, default: 0, precision: 13, scale: 4
      t.decimal  :shipped_qty, precision: 13, scale: 4
      t.string   :qty_unit
      t.string   :currency_code
      t.decimal  :total_cost, null: false, default: 0, precision: 13, scale: 4
      t.string   :account
      t.datetime :updated_date_utc

      t.timestamps
    end

    add_index :refinery_business_orders, :order_id
    add_index :refinery_business_orders, :buyer_id
    add_index :refinery_business_orders, :buyer_label
    add_index :refinery_business_orders, :seller_id
    add_index :refinery_business_orders, :seller_label
    add_index :refinery_business_orders, :project_id
    add_index :refinery_business_orders, :order_number
    add_index :refinery_business_orders, :order_type
    add_index :refinery_business_orders, :order_date
    add_index :refinery_business_orders, :version_number
    add_index :refinery_business_orders, :revised_date
    add_index :refinery_business_orders, :reference
    add_index :refinery_business_orders, :delivery_date
    add_index :refinery_business_orders, :ship_mode
    add_index :refinery_business_orders, :shipment_terms
    add_index :refinery_business_orders, :attention_to
    add_index :refinery_business_orders, :status
    add_index :refinery_business_orders, :proforma_invoice_label
    add_index :refinery_business_orders, :invoice_label
    add_index :refinery_business_orders, :ordered_qty
    add_index :refinery_business_orders, :shipped_qty
    add_index :refinery_business_orders, :qty_unit
    add_index :refinery_business_orders, :currency_code
    add_index :refinery_business_orders, :total_cost
    add_index :refinery_business_orders, :account
    add_index :refinery_business_orders, :updated_date_utc
  end

end
