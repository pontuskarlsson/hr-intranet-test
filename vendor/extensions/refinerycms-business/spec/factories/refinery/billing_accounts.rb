FactoryBot.define do
  factory :billing_account, :class => Refinery::Business::BillingAccount do
    company
    name { |evaluator| evaluator.company.name }
  end
end
