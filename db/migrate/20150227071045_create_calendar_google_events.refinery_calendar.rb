# This migration comes from refinery_calendar (originally 10)
class CreateCalendarGoogleEvents < ActiveRecord::Migration

  def change
    create_table :refinery_calendar_google_events do |t|
      t.integer :google_calendar_id
      t.integer :event_id
      t.string :google_event_id
      t.datetime :last_synced_at

      t.timestamps
    end

    add_index :refinery_calendar_google_events, :google_calendar_id,  name: 'index_rcge_on_google_calendar_id'
    add_index :refinery_calendar_google_events, :event_id,            name: 'index_rcge_on_event_id'
    add_index :refinery_calendar_google_events, :google_event_id,     name: 'index_rcge_on_google_event_id'
  end

end
