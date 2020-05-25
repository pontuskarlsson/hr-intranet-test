FactoryBot.define do
  factory :cause, :class => Refinery::QualityAssurance::Cause do
    sequence(:category_code) { |n| n }
    sequence(:category_name) { |n| "Category ##{n}" }
    sequence(:cause_code) { |n| n }
    sequence(:cause_name) { |n| "Cause ##{n}" }
  end
end

