# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    sequence(:guid) { |n| "Uniq-GUID-#{n}" }
    sequence(:name) { |n| "Company Hey #{n}" }
  end
end
