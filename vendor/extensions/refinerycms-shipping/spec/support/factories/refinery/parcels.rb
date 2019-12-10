
FactoryGirl.define do
  factory :parcel, :class => Refinery::Shipping::Parcel do
    sequence(:from_name) { |n| "refinery#{n}" }
    association :received_by, factory: :user
    parcel_date { '2013-12-31' }
    courier { 'Fastest Parcels Inc.' }
    to_name { 'Jane Deer' }
  end
end

