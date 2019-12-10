module Refinery
  module Calendar
    module Admin
      class EventsController < ::Refinery::AdminController
        before_action :find_venues, :except => [:index, :destroy]
        before_action :find_calendars, :except => [:index, :destroy]

        crudify :'refinery/calendar/event',
                :sortable => false,
                :order => "starts_at DESC"

        private
        def find_venues
          @venues = ::Refinery::Calendar::Venue.order('name')
        end

        def find_calendars
          @calendars = ::Refinery::Calendar::Calendar.includes(:user).order('title')
        end

        def event_params
          params.require(:event).permit(
              :title, :from, :to, :registration_link, :venue_id, :excerpt,
              :description, :featured, :position, :calendar_id
          )
        end
      end
    end
  end
end
