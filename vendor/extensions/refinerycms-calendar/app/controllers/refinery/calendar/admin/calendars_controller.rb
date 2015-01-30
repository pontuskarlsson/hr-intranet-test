module Refinery
  module Calendar
    module Admin
      class CalendarsController < ::Refinery::AdminController
        before_filter :find_users, :except => [:index, :destroy]

        crudify :'refinery/calendar/calendar',
                :title_attribute => 'title',
                :xhr_paging => true,
                :sortable => false,
                :order => 'created_at DESC'

        private
        def find_users
          @users = User.order('username')
        end
      end
    end
  end
end
