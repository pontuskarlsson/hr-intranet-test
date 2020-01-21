
FactoryBot.define do
  factory :google_event, :class => Refinery::Calendar::GoogleEvent do
    google_calendar
    event { |google_event| FactoryBot.create(:event, calendar: google_event.google_calendar.primary_calendar) }
    sequence(:google_event_id) { |n| "1234567890#{n}" }
  end
end

