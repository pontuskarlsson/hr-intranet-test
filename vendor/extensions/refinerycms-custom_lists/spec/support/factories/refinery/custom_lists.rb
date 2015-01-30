
FactoryGirl.define do
  factory :custom_list, :class => Refinery::CustomLists::CustomList do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

