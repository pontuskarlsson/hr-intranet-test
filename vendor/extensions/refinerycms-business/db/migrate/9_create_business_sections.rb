class CreateBusinessSections < ActiveRecord::Migration

  def change
    create_table :refinery_business_sections do |t|
      t.integer :project_id
      t.string :section_type
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :budgeted_resources

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_sections, :project_id
    add_index :refinery_business_sections, :section_type
    add_index :refinery_business_sections, :start_date
    add_index :refinery_business_sections, :end_date

    add_index :refinery_business_sections, :position
  end

end
