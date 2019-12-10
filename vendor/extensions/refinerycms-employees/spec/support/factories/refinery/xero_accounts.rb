
FactoryGirl.define do
  factory :xero_account, :class => Refinery::Employees::XeroAccount do
    sequence(:guid) { |n| "00000000-0000-0000-0000-#{ n.to_s.rjust(12, '0') }" }
    sequence(:code) { |n| n.to_s.rjust(4, '0') }
    name { 'Travel' }
  end
end

