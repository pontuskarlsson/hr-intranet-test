
FactoryGirl.define do
  factory :product, :class => Refinery::Store::Product do
    retailer
    sequence(:product_number) { |n| "refinery#{n}" }
    name 'A Name'
    description 'A Description'
    measurement_unit 'pcs'
    price_amount 100
  end
end

