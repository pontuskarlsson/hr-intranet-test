FactoryGirl.define do
  factory :event, class: Refinery::Calendar::Event do
    title 'Festival'
    starts_at DateTime.now + 5.days
    ends_at DateTime.now + 6.days
  end
end
