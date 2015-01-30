class CreateMarketingBrandShows < ActiveRecord::Migration

  def up
    create_table :refinery_brand_shows do |t|
      t.integer :brand_id
      t.integer :show_id

      t.timestamps
    end

    add_index :refinery_brand_shows, :brand_id
    add_index :refinery_brand_shows, :show_id
  end

  def down
    remove_index :refinery_brand_shows, :brand_id
    remove_index :refinery_brand_shows, :show_id

    drop_table :refinery_brand_shows

  end

end
