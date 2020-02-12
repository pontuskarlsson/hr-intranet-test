FactoryBot.define do
  factory :plan, :class => Refinery::Business::Plan do
    account
    company
    sequence(:reference) { |n| "PL#{n.to_s.rjust(5, '0')}" }
    title { 'Monthly Plan' }
    description { 'A description of a monthly plan.' }
    currency_code { ::Refinery::Business::Invoice::CURRENCY_CODES.first }
    status { 'draft' }
  end
end
