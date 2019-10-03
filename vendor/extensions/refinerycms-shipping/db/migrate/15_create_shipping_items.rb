class CreateShippingItems < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_items do |t|
      t.integer :shipment_id
      t.integer :order_id
      t.string :order_label
      t.integer :order_item_id
      t.string :article_code
      t.string :description
      t.boolean :partial_shipment, null: false, default: false
      t.integer :qty

      t.timestamps
    end

  end

end
