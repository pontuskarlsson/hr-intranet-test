
FactoryGirl.define do
  factory :sales_order, :class => Refinery::Business::SalesOrder do
    sequence(:order_ref) { |n| "refinery#{n}" }
    company 'Company Ltd.'
    total 100
    currency_name 'USD'
  end
end
