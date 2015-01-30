
FactoryGirl.define do
  factory :contact, :class => Refinery::Marketing::Contact do
    sequence(:base_id) { |n| n }
    name 'John Doe'
    sequence(:email) { |n| "#{n}@foo.com" }
    sequence(:tags_joined_by_comma) { |n| 'abcdefghijklmnopqrstuvwxyz'[n] * 5 }
  end
end

