class CreateEmployeesXeroTrackingCategories < ActiveRecord::Migration

  def change
    create_table :refinery_xero_tracking_categories do |t|
      t.string :guid
      t.string :name
      t.string :status
      t.text :options

      t.timestamps
    end

    add_index :refinery_xero_tracking_categories, :guid
    add_index :refinery_xero_tracking_categories, :name
    add_index :refinery_xero_tracking_categories, :status

    # Add a column to store the settings for default options for tracking categories
    add_column :refinery_employees, :default_tracking_options, :text

    # Add columns to specify tracking category option for line items
    add_column :refinery_xero_line_items, :tracking_categories_and_options, :text
  end

end
