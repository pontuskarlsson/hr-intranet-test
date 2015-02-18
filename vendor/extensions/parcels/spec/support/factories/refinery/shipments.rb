
FactoryGirl.define do
  factory :shipment, :class => Refinery::Parcels::Shipment do
    association :created_by,  factory: :user
    association :from_address, factory: :shipment_address
    association :to_address, factory: :shipment_address
    courier ::Refinery::Parcels::Shipment::COURIERS.first
  end
end

