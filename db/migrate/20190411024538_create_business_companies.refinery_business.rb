# This migration comes from refinery_business (originally 6)
class CreateBusinessCompanies < ActiveRecord::Migration

  def change
    create_table :refinery_business_companies do |t|
      t.integer :contact_id
      t.string :code
      t.string :name

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_companies, :contact_id
    add_index :refinery_business_companies, :code
    add_index :refinery_business_companies, :name

    add_index :refinery_business_companies, :position
  end

end
