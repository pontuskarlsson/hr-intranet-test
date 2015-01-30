
FactoryGirl.define do
  factory :brand, :class => Refinery::Marketing::Brand do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

