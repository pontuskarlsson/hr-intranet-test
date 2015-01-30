
FactoryGirl.define do
  factory :show, :class => Refinery::Marketing::Show do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

