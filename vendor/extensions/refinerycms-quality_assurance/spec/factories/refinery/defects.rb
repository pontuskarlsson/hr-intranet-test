FactoryBot.define do
  factory :defect, :class => Refinery::QualityAssurance::Defect do
    sequence(:category_code) { |n| n }
    sequence(:category_name) { |n| "Category ##{n}" }
    sequence(:defect_code) { |n| n }
    sequence(:defect_name) { |n| "Defect ##{n}" }
  end
end

