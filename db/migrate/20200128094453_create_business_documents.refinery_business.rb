# This migration comes from refinery_business (originally 28)
class CreateBusinessDocuments < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_business_documents do |t|
      t.integer :company_id
      t.integer :request_id
      t.integer :resource_id

      t.string :document_type
      t.text :comments
      t.text :meta

      t.timestamps
    end

    add_index :refinery_business_documents, :company_id
    add_index :refinery_business_documents, :request_id
    add_index :refinery_business_documents, :resource_id
    add_index :refinery_business_documents, :document_type
  end

end
