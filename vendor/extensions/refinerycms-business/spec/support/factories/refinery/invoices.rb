
FactoryGirl.define do
  factory :invoice, :class => Refinery::Business::Invoice do
    account
    company
    sequence(:invoice_number) { |n| "INV-#{n.to_s.rjust(5, '0')}" }
    invoice_type { 'ACCREC' }
    invoice_date { 1.month.ago }
    due_date { |evaluator| evaluator.invoice_date && evaluator.invoice_date + 3.months }
    status { 'DRAFT' }
    currency_code { 'USD' }
    is_managed { true }


    factory :invoice_with_id do
      invoice_id { SecureRandom.uuid }
    end
  end
end
