
FactoryGirl.define do
  factory :xero_contact, :class => Refinery::Employees::XeroContact do
    sequence(:guid) { |n| "00000000-0000-0000-0000-#{ n.to_s.rjust(12, '0') }" }
    sequence(:name) { |n| "John Doe the #{n.ordinalize}" }
  end
end

