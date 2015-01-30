module Refinery
  module Employees
    module Admin
      class PublicHolidaysController < ::Refinery::AdminController

        crudify :'refinery/employees/public_holiday',
                :title_attribute => 'title',
                :xhr_paging => true,
                order: 'holiday_date DESC'

      end
    end
  end
end
