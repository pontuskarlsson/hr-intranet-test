class CreateMarketingCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_marketing_campaigns do |t|
      t.string :title
      t.string :slug
      t.text :meta

      t.timestamps
    end
    add_index :refinery_marketing_campaigns, :title
    add_index :refinery_marketing_campaigns, :slug
  end
end
