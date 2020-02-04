
FactoryBot.define do
  factory :user_calendar, class: Refinery::Calendar::UserCalendar do
    association :user, factory: :authentication_devise_user
    calendar
    inactive { false }
  end
end

