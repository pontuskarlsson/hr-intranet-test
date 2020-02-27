# This migration comes from refinery_marketing (originally 14)
class CreateMarketingLandingPages < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_marketing_landing_pages do |t|
      t.integer :campaign_id
      t.integer :page_id
      t.string :title
      t.string :slug
      t.text :meta

      t.timestamps
    end
    add_index :refinery_marketing_landing_pages, :campaign_id
    add_index :refinery_marketing_landing_pages, :page_id
    add_index :refinery_marketing_landing_pages, :title
    add_index :refinery_marketing_landing_pages, :slug
  end
end
