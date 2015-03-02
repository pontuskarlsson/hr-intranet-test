require 'google_calendar'

module Refinery
  module Calendar
    class GoogleClient
      CLIENT_ID     = ENV['GOOGLE_CLIENT_ID']
      CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']

      attr_accessor :calendar_id, :refresh_token

      def initialize(calendar_id, refresh_token = nil)
        @calendar_id, @refresh_token = calendar_id, refresh_token
      end

      def cal
        @cal ||= ::Google::Calendar.new(
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            calendar: calendar_id,
            refresh_token: refresh_token,
            redirect_url: 'http://dev-intra.happyrabbit.com:3000/refinery/calendar/google_calendars/oauth2callback' # this is what Google uses for 'applications'
        )
      end

      def create_event_for(event)
        cal.create_event do |e|
          e.title       = event.title
          e.description = event.description
          e.start_time  = event.starts_at
          e.end_time    = event.ends_at
        end
      end

      # A method to sync the Event on the Intranet to the Calendar
      # on Google. The argument +event+ is the Event model and +evt+
      # is an instance of the Event from google.
      def sync_event_to(event, evt)
        evt.title       = event.title
        evt.description = event.description
        evt.start_time  = event.starts_at
        evt.end_time    = event.ends_at
        evt.save
      end

    end
  end
end
