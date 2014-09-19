
FactoryGirl.define do
  factory :brand, :class => Refinery::Brands::Brand do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

