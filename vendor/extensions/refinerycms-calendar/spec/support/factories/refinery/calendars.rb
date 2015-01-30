
FactoryGirl.define do
  factory :calendar, :class => Refinery::Calendar::Calendar do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

