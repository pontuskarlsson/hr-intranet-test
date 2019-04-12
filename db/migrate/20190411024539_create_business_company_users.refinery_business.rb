# This migration comes from refinery_business (originally 7)
class CreateBusinessCompanyUsers < ActiveRecord::Migration

  def change
    create_table :refinery_business_company_users do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :role

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_company_users, :company_id
    add_index :refinery_business_company_users, :user_id
    add_index :refinery_business_company_users, :role

    add_index :refinery_business_company_users, :position
  end

end
