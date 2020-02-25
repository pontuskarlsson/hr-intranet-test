class CreateMarketingLandingPages < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_marketing_landing_pages do |t|
      t.integer :campaign_id
      t.integer :page_id
      t.string :title
      t.text :meta

      t.timestamps
    end
    add_index :refinery_marketing_landing_pages, :campaign_id
    add_index :refinery_marketing_landing_pages, :page_id
    add_index :refinery_marketing_landing_pages, :title
  end
end
