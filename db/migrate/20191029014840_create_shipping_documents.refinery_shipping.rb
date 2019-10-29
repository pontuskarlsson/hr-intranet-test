# This migration comes from refinery_shipping (originally 19)
class CreateShippingDocuments < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_documents do |t|
      t.integer :shipment_id
      t.integer :resource_id

      t.string :document_type
      t.text :comments

      t.timestamps
    end

    add_index :refinery_shipping_documents, :shipment_id
    add_index :refinery_shipping_documents, :resource_id
    add_index :refinery_shipping_documents, :document_type
  end

end
