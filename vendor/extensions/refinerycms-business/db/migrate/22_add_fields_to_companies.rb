class AddFieldsToCompanies < ActiveRecord::Migration

  def change
    add_column :refinery_business_companies, :country_code, :string
    add_index :refinery_business_companies, :country_code

    add_column :refinery_business_companies, :city, :string
    add_index :refinery_business_companies, :city

    add_column :refinery_business_companies, :verified_at, :datetime
    add_index :refinery_business_companies, :verified_at

    add_column :refinery_business_companies, :verified_by_id, :integer
    add_index :refinery_business_companies, :verified_by_id
  end

end
