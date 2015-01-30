class CreateMarketingShows < ActiveRecord::Migration

  def up
    create_table :refinery_shows do |t|
      t.string :name
      t.string :website
      t.integer :logo_id
      t.text :description
      t.text :msg_json_struct
      t.datetime :last_sync_datetime
      t.string :last_sync_result
      t.integer :position

      t.timestamps
    end

  end

  def down

    drop_table :refinery_shows

  end

end
