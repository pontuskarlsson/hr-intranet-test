# This migration comes from refinery_calendar (originally 9)
class CreateCalendarGoogleCalendars < ActiveRecord::Migration

  def change
    create_table :refinery_calendar_google_calendars do |t|
      t.integer :user_id
      t.integer :primary_calendar_id
      t.string :google_calendar_id
      t.string :refresh_token
      t.integer :sync_to_id,            null: false, default: 0
      t.integer :sync_from_id,          null: false, default: 0

      t.timestamps
    end

    add_index :refinery_calendar_google_calendars, :user_id,              name: 'index_rcgc_on_user_id'
    add_index :refinery_calendar_google_calendars, :primary_calendar_id,  name: 'index_rcgc_on_primary_calendar_id'
    add_index :refinery_calendar_google_calendars, :google_calendar_id,   name: 'index_rcgc_on_google_calendar_id'
  end

end
