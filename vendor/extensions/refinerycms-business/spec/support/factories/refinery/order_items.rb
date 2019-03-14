
FactoryGirl.define do
  factory :business_order_item, :class => Refinery::Business::OrderItem do
    sales_order
    code '123'
    qty 1
    price 100
  end
end

