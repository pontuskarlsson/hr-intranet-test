
FactoryGirl.define do
  factory :event, :class => Refinery::Calendar::Event do
    calendar
    sequence(:title) { |n| "refinery#{n}" }
  end
end

