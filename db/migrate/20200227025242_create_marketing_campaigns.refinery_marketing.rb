# This migration comes from refinery_marketing (originally 13)
class CreateMarketingCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_marketing_campaigns do |t|
      t.string :title
      t.text :meta

      t.timestamps
    end
    add_index :refinery_marketing_campaigns, :title
  end
end
