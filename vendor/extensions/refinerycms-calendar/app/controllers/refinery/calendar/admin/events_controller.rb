module Refinery
  module Calendar
    module Admin
      class EventsController < ::Refinery::AdminController
        before_filter :find_venues, :except => [:index, :destroy]
        before_filter :find_calendars, :except => [:index, :destroy]

        crudify :'refinery/calendar/event',
                :xhr_paging => true,
                :sortable => false,
                :order => "starts_at DESC"

        private
        def find_venues
          @venues = ::Refinery::Calendar::Venue.order('name')
        end

        def find_calendars
          @calendars = ::Refinery::Calendar::Calendar.includes(:user).order('title')
        end
      end
    end
  end
end
