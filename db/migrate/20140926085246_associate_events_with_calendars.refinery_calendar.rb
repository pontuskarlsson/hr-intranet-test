# This migration comes from refinery_calendar (originally 8)
class AssociateEventsWithCalendars < ActiveRecord::Migration

  def up
    add_column :refinery_calendar_events, :calendar_id, :integer

    add_index :refinery_calendar_events, :calendar_id
  end

  def down
    remove_index :refinery_calendar_events, :calendar_id

    remove_column :refinery_calendar_events, :calendar_id
  end

end
