class AddFieldsToCompanies < ActiveRecord::Migration

  def change
    add_column :refinery_business_companies, :country_code, :string
    add_index :refinery_business_companies, :country_code

    add_column :refinery_business_companies, :city, :string
    add_index :refinery_business_companies, :city
  end

end
