class CreateCalendarCalendars < ActiveRecord::Migration

  def up
    create_table :refinery_calendar_calendars do |t|
      t.string :title
      t.string :function
      t.integer :user_id
      t.boolean :private,       null: false, default: 0
      t.string :default_rgb_code

      t.integer :position

      t.timestamps
    end

    add_index :refinery_calendar_calendars, :function
    add_index :refinery_calendar_calendars, :user_id
    add_index :refinery_calendar_calendars, :private
    add_index :refinery_calendar_calendars, :position

  end

  def down
    remove_index :refinery_calendar_calendars, :function
    remove_index :refinery_calendar_calendars, :user_id
    remove_index :refinery_calendar_calendars, :private
    remove_index :refinery_calendar_calendars, :position

    drop_table :refinery_calendar_calendars

  end

end
