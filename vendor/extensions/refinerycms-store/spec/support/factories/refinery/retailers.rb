
FactoryGirl.define do
  factory :retailer, :class => Refinery::Store::Retailer do
    sequence(:name) { |n| "refinery#{n}" }
    default_price_unit 'HKD'
  end
end

