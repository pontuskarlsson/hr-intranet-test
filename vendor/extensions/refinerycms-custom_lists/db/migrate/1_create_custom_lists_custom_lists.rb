class CreateCustomListsCustomLists < ActiveRecord::Migration

  def up
    create_table :refinery_custom_lists_custom_lists do |t|
      t.string :title
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-custom_lists"})
    end

    drop_table :refinery_custom_lists_custom_lists

  end

end
