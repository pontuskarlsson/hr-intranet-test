class CreateCalendarUserCalendars < ActiveRecord::Migration

  def up
    create_table :refinery_calendar_user_calendars do |t|
      t.integer :user_id
      t.integer :calendar_id
      t.boolean :inactive,    null: false, default: 0
      t.string :rgb_code

      t.timestamps
    end

    add_index :refinery_calendar_user_calendars, :calendar_id
    add_index :refinery_calendar_user_calendars, :user_id
    add_index :refinery_calendar_user_calendars, :inactive

  end

  def down
    remove_index :refinery_calendar_user_calendars, :calendar_id
    remove_index :refinery_calendar_user_calendars, :user_id
    remove_index :refinery_calendar_user_calendars, :inactive

    drop_table :refinery_calendar_user_calendars

  end

end
