class AddFieldsToCompanies < ActiveRecord::Migration

  def change
    add_column :refinery_business_companies, :country, :string
    add_index :refinery_business_companies, :country

    add_column :refinery_business_companies, :city, :string
    add_index :refinery_business_companies, :city
  end

end
