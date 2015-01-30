
FactoryGirl.define do
  factory :shipment, :class => Refinery::Parcels::Shipment do
    association :from_address, factory: :shipment_address
    association :to_address, factory: :shipment_address
    association :assigned_to, factory: :user
    courier ::Refinery::Parcels::Shipment::COURIERS.first
  end
end

