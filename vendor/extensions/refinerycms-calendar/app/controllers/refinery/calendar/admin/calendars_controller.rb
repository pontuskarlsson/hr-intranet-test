module Refinery
  module Calendar
    module Admin
      class CalendarsController < ::Refinery::AdminController
        before_action :find_users, :except => [:index, :destroy]

        crudify :'refinery/calendar/calendar',
                :title_attribute => 'title',
                :sortable => false,
                :order => 'created_at DESC'

        def calendar_params
          params.require(:calendar).permit(
              :default_rgb_code, :private, :activate_on_create, :user_id, :function, :title, :position
          )
        end

        private
        def find_users
          @users = User.order('username')
        end
      end
    end
  end
end
