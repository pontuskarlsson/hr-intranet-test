FactoryBot.define do
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


    factory :invoice_with_all_items do
      invoice_for_month { Date.parse '2019-01-01' }
      invoice_date { Date.parse '2019-01-31' }
      plan_title { 'Monthly Invoice' }
      plan_description { 'Description of monthly invoice' }

      after(:create) do |invoice, evaluator|
        billable = FactoryBot.create(:billable, company: invoice.company, invoice: invoice, billable_date: invoice.invoice_for_month)

      end
    end
  end
end
