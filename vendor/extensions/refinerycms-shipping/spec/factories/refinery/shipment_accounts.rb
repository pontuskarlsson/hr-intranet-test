
FactoryBot.define do
  factory :shipment_account, :class => Refinery::Shipping::ShipmentAccount do
    contact { FactoryBot.create(:contact) }
    sequence(:account_no) { |n| "00000#{n}" }
    description {
      [courier, account_no, contact.try(:name)].compact.join(', ')
    }
  end
end

