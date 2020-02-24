module Refinery
  module Calendar
    class EventsController < ::ApplicationController
      before_action :find_page,           except: [:archive, :create]
      before_action :find_event,          except: [:archive, :new, :create, :index]
      before_action :auth_or_create_cal,  only: :create


      helper_method :personal_calendars

      def new
        @event = ::Refinery::Calendar::Event.new(from: '2015-03-26 09:00:00')
        @venues = ::Refinery::Calendar::Venue.order('name')
      end

      def create
        @event = @calendar.events.build(event_params)
        if @event.save
          flash[:notice] = 'Event successfully created'
        else
          flash[:alert] = 'Failed to create Event'
        end
        redirect_to refinery.calendar_events_path
      end

      def index
        @calendars = ::Refinery::Calendar::Calendar.visible_for_user(current_refinery_user)
        @active_calendars = ::Refinery::Calendar::Calendar.active_for_user(current_refinery_user)
        @events = ::Refinery::Calendar::Event.in_calendars(@calendars).includes(:calendar).order('refinery_calendar_events.starts_at DESC')

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        present(@page)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        present(@page)
      end

      def edit
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        present(@page)
      end

      def update
        if @event.calendar.allows_event_update_by?(current_refinery_user)
          if @event.update_attributes(event_params)
            flash[:notice] = 'Successfully updated event'
          else
            flash[:alert] = 'Failed to update event'
          end
        end
        redirect_to refinery.calendar_events_path
      end

      def destroy
        if @event.calendar.allows_event_update_by?(current_refinery_user)
          if @event.destroy
            flash[:notice] = 'Successfully removed event'
          else
            flash[:alert] = 'Failed to remove event'
          end
        end
        redirect_to refinery.calendar_events_path
      end

      def archive
        @events = ::Refinery::Calendar::Event.archive.order('refinery_calendar_events.starts_at DESC')
        render :template => 'refinery/calendar/events/index'
      end

      protected
      def find_page
        @page = ::Refinery::Page.find_authorized_by_link_url!('/calendar/events', current_refinery_user)
      rescue ::ActiveRecord::RecordNotFound
        error_404
      end

      def find_event
        @event = ::Refinery::Calendar::Event.find(params[:id])
      rescue StandardError
        flash[:alert] = 'Could not find Event'
        redirect_to refinery.calendar_events_path
      end

      def personal_calendars
        @personal_calendars ||= ::Refinery::Calendar::Calendar.where(user_id: current_refinery_user.id)
      rescue StandardError
        []
      end

      def auth_or_create_cal
        if params[:event]
          if params[:event][:calendar_id]
            cal_id = params[:event].delete(:calendar_id).to_i
            @calendar = personal_calendars.detect { |c| c.id == cal_id }
          elsif params[:event][:new_calendar_title]
            @calendar = ::Refinery::Calendar::Calendar.create(
                title: params[:event].delete(:new_calendar_title),
                private: params[:event].delete(:private),
                user_id: current_refinery_user.id,
                activate_on_create: '1')
          end
        end
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
