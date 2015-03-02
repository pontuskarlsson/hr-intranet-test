module Refinery
  module Calendar
    module Admin
      class GoogleCalendarsController < ::Refinery::AdminController
        before_filter :find_users,      except: [:index, :destroy, :oauth2, :oauth2callback]
        before_filter :find_calendars,  except: [:index, :destroy, :oauth2, :oauth2callback]

        crudify :'refinery/calendar/google_calendar',
                :title_attribute => 'google_calendar_id',
                :xhr_paging => true,
                :sortable => false,
                :order => 'created_at DESC'

        def oauth2
          @google_calendar = ::Refinery::Calendar::GoogleCalendar.find params[:id]
          session[:oauth_calendar_id] = @google_calendar.id
          redirect_to @google_calendar.google_authorize_url
        end

        def oauth2callback
          @google_calendar = ::Refinery::Calendar::GoogleCalendar.find session.delete(:oauth_calendar_id)
          @google_calendar.access_code = params[:code]
          @google_calendar.save!
          redirect_to refinery.edit_calendar_admin_google_calendar_path(@google_calendar)
        end

        private
        def find_users
          @users = User.order('username')
        end

        def find_calendars
          @calendars = ::Refinery::Calendar::Calendar.order('title')
        end
      end
    end
  end
end
