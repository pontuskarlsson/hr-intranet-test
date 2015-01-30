
FactoryGirl.define do
  factory :order_item, :class => Refinery::Store::OrderItem do
    order # association :order, factory: :order
    sequence(:product_number) { |n| "refinery#{n}" }
    price_per_item 100
    quantity 1
  end
end

