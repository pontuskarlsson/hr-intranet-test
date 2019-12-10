
FactoryGirl.define do
  factory :shipment_address, :class => Refinery::Shipping::Address do
    name { 'John Doe' }
    company { 'Wildlife Hunting' }
    street1 { '123 Wild Grove' }
    city { 'Hong Kong' }
    country { 'HK' }
  end
end

