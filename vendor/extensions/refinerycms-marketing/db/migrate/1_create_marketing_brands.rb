class CreateMarketingBrands < ActiveRecord::Migration

  def up
    create_table :refinery_brands do |t|
      t.string :name
      t.string :website
      t.integer :logo_id
      t.text :description
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-marketing"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/marketing/brands"})
    end

    drop_table :refinery_brands

  end

end
