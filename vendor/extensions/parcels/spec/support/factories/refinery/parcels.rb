
FactoryGirl.define do
  factory :parcel, :class => Refinery::Parcels::Parcel do
    sequence(:from_name) { |n| "refinery#{n}" }
  end
end

