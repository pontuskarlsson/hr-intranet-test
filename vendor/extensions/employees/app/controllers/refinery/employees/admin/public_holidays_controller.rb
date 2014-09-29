module Refinery
  module Employees
    module Admin
      class PublicHolidaysController < ::Refinery::AdminController

        crudify :'refinery/employees/public_holiday',
                :title_attribute => 'title',
                :xhr_paging => true

      end
    end
  end
end
