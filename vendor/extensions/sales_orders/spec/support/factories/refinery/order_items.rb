
FactoryGirl.define do
  factory :order_item, :class => Refinery::SalesOrders::OrderItem do
    sales_order
    code '123'
    order_qty 1
    unit_price 100
    total_price 100
  end
end

