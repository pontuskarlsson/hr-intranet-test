class CreateEmployeesXeroContacts < ActiveRecord::Migration

  def up
    create_table :refinery_xero_contacts do |t|
      t.string :guid
      t.string :contact_number
      t.string :contact_status
      t.string :name
      t.string :tax_number
      t.string :bank_account_details
      t.string :accounts_receivable_tax_type
      t.string :accounts_payable_tax_type
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :skype_user_name
      t.string :contact_groups
      t.string :default_currency
      t.datetime :updated_date_utc
      t.boolean :is_supplier,     null: false, default: 0
      t.boolean :is_customer,     null: false, default: 0

      t.timestamps
    end

    add_index :refinery_xero_contacts, :guid
  end

  def down
    remove_index :refinery_xero_contacts, :guid

    drop_table :refinery_xero_contacts

  end

end
