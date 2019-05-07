class AddXeroFieldsToMarketingContacts < ActiveRecord::Migration

  def change
    add_column :refinery_contacts, :xero_hr_id, :string
    add_index :refinery_contacts, :xero_hr_id

    add_column :refinery_contacts, :xero_hrt_id, :string
    add_index :refinery_contacts, :xero_hrt_id

    add_column :refinery_contacts, :mailchimp_id, :string
    add_index :refinery_contacts, :mailchimp_id
  end

end
