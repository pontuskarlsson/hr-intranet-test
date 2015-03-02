namespace :refinery do

  namespace :calendar do

    # call this task by running: rake refinery:calendar:my_task
    # desc "Description of my task below"
    # task :my_task => :environment do
    #   # add your logic here
    # end
    task :sync_with_google => :environment do
      ::Refinery::Calendar::GoogleCalendar.active_sync.each do |google_calendar|

        if google_calendar.sync_to_all_visible?
          # Retrieve all the calendars that is currently configured as visible for the user.
          active_calendars = ::Refinery::Calendar::Calendar.active_for_user(google_calendar.user)

          # Retrieve all events from those calendars
          events = ::Refinery::Calendar::Event.in_calendars(active_calendars).
              where('starts_at > ? AND starts_at < ?', Date.today - 1.week, Date.today + 3.months)

          events.each do |event|
            if (ge = google_calendar.google_events.detect { |e| e.event_id == event.id }).present?
              # Existing Event
              if ge.last_synced_at < event.updated_at
                # The event in the google calendar was last synced prior to the latest update of
                # the event. So we need to update it
                if (evt = google_calendar.google_client.cal.find_event_by_id(ge.google_event_id)).present?
                  google_calendar.google_client.sync_event_to(event, evt)
                end

              end

            else
              # New Event
              evt = google_calendar.google_client.create_event_for event
              google_calendar.google_events.create(event_id: event.id, google_event_id: evt.id, last_synced_at: DateTime.now)

            end
          end


        end

      end
    end

  end

end