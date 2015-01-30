
FactoryGirl.define do
  factory :order, :class => Refinery::Store::Order do
    retailer
    sequence(:order_number) { |n| "refinery#{n}" }
  end
end

