# This migration comes from refinery_business (originally 10)
class CreateBusinessNumberSeries < ActiveRecord::Migration

  def change
    create_table :refinery_business_number_series do |t|
      t.string :identifier
      t.integer :last_counter

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_number_series, :identifier
    add_index :refinery_business_number_series, :last_counter

    add_index :refinery_business_number_series, :position
  end

end
