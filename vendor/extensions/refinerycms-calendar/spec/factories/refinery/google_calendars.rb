
FactoryBot.define do
  factory :google_calendar, :class => Refinery::Calendar::GoogleCalendar do
    association :user, factory: :authentication_devise_user
    primary_calendar { |google_calendar| FactoryBot.create(:calendar, user: google_calendar.user) }
    sequence(:google_calendar_id) { |n| "00000000000-#{n}" }

    # A factory to make sure that the record has a refresh
    # token set. This has to be done in two steps since it
    # will be cleared if the Google Calendar ID is changed
    # (which it is when it is created).
    factory :google_calendar_with_refresh_token do
      after(:create) do |google_calendar, evaluator|
        google_calendar.refresh_token = '192837465'
        google_calendar.save!
      end
    end

  end
end

