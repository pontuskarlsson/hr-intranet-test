module Refinery
  module Employees
    module Admin
      class PublicHolidaysController < ::Refinery::AdminController

        crudify :'refinery/employees/public_holiday',
                :title_attribute => 'title',
                order: 'holiday_date DESC'

        def public_holiday_params
          params.require(:public_holiday).permit(
              :holiday_date, :half_day, :country, :title
          )
        end
      end
    end
  end
end
