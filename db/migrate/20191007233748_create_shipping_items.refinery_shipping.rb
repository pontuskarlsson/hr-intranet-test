# This migration comes from refinery_shipping (originally 15)
class CreateShippingItems < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_items do |t|
      t.integer :shipment_id

      t.integer :order_id
      t.string :order_label
      t.integer :order_item_id

      t.string :article_code
      t.string :description

      t.string :hs_code_label

      t.boolean :partial_shipment, null: false, default: false
      t.decimal :qty, precision: 13, scale: 4

      t.integer :item_order

      t.timestamps
    end

  end

end
