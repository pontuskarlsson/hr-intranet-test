class CreateBusinessRequests < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_business_requests do |t|
      t.string :code
      t.integer :company_id
      t.integer :created_by_id
      t.integer :requested_by_id
      t.string :participants

      t.string :request_type
      t.string :status

      t.string :subject
      t.date :request_date
      t.text :description
      t.text :comments

      t.datetime :archived_at

      t.timestamps
    end

    add_index :refinery_business_requests, :code
    add_index :refinery_business_requests, :company_id
    add_index :refinery_business_requests, :created_by_id
    add_index :refinery_business_requests, :requested_by_id
    add_index :refinery_business_requests, :participants
    add_index :refinery_business_requests, :request_type
    add_index :refinery_business_requests, :status
    add_index :refinery_business_requests, :subject
    add_index :refinery_business_requests, :request_date
    add_index :refinery_business_requests, :archived_at
  end

end
