# This migration comes from refinery_business (originally 8)
class CreateBusinessProjects < ActiveRecord::Migration

  def change
    create_table :refinery_business_projects do |t|
      t.integer :company_id
      t.string :code
      t.text :description
      t.string :status
      t.date :start_date
      t.date :end_date

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_projects, :company_id
    add_index :refinery_business_projects, :code
    add_index :refinery_business_projects, :status
    add_index :refinery_business_projects, :start_date
    add_index :refinery_business_projects, :end_date

    add_index :refinery_business_projects, :position
  end

end
