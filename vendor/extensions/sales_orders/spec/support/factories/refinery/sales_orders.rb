
FactoryGirl.define do
  factory :sales_order, :class => Refinery::SalesOrders::SalesOrder do
    sequence(:order_id) { |n| "refinery#{n}" }
  end
end
