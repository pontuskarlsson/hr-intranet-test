FactoryBot.define do
  factory :company, :class => Refinery::Business::Company do
    sequence(:name) { |n| "Amazing #{n} Ltd." }
  end
end
