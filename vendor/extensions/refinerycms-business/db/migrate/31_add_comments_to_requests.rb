class AddCommentsToRequests < ActiveRecord::Migration[5.1]

  def change
    add_column :refinery_business_requests, :zendesk_id, :integer, limit: 8
    add_index :refinery_business_requests, :zendesk_id

    add_column :refinery_business_requests, :zendesk_meta, :text

    add_column :refinery_business_requests, :requested_services, :text
  end

end
