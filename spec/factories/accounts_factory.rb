# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:guid) { |n| "Unique-GUID-#{n}" }
    sequence(:code) { |n| "00#{n}0" }
    sequence(:name) { |n| "Account Name ##{n}" }
  end
end
