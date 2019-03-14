module Refinery
  module Calendar
    class UserCalendar < Refinery::Core::BaseModel
      belongs_to :user,  class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :calendar

      validates :user_id,       presence: true
      validates :calendar_id,   presence: true, uniqueness: { scope: :user_id }

      before_create do
        self.rgb_code = calendar.try(:default_rgb_code) if rgb_code.blank?
      end

    end
  end
end
