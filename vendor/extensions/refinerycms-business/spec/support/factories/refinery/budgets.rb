
FactoryGirl.define do
  factory :budget, :class => Refinery::Business::Budget do
    sequence(:description) { |n| "refinery#{n}" }
  end
end
