
FactoryGirl.define do
  factory :shipment_account, :class => Refinery::Shipping::ShipmentAccount do
    contact { FactoryGirl.create(:contact) }
    sequence(:account_no) { |n| "00000#{n}" }
    courier { Refinery::Shipping::Shipment.easypost_couriers.first }
    description {
      [courier, account_no, contact.try(:name)].compact.join(', ')
    }
  end
end

