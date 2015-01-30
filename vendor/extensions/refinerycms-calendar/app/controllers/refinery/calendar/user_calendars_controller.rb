module Refinery
  module Calendar
    class UserCalendarsController < ::ApplicationController

      def create
        @user_calendar = UserCalendar.find_or_initialize_by_user_id_and_calendar_id(current_refinery_user.id, user_calendar_params[:calendar_id])
        @user_calendar.inactive = user_calendar_params[:inactive]
        if @user_calendar.save
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

    protected
      def user_calendar_params
        params[:user_calendar] || {}
      end

    end
  end
end
