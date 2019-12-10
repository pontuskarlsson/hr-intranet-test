
FactoryGirl.define do
  factory :user_calendar, class: Refinery::Calendar::UserCalendar do
    user
    calendar
    inactive { false }
  end
end

