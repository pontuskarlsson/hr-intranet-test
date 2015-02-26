
FactoryGirl.define do
  factory :event, :class => Refinery::Calendar::Event do
    calendar
    sequence(:title) { |n| "refinery#{n}" }
    starts_at '2001-01-01 09:00:00 UTC'
  end
end

