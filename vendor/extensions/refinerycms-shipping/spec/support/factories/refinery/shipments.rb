
FactoryGirl.define do
  factory :shipment, :class => Refinery::Shipping::Shipment do
    association :created_by,  factory: :user
    assigned_to { |shipment| shipment.created_by }
    association :from_address, factory: :shipment_address
    association :to_address, factory: :shipment_address
    bill_to { ::Refinery::Shipping::Shipment::BILL_TO.first }
  end
end

