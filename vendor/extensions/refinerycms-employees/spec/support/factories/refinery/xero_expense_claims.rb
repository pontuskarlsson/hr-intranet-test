
FactoryGirl.define do
  factory :xero_expense_claim, :class => Refinery::Employees::XeroExpenseClaim do
    association :added_by, factory: :authentication_devise_user
    employee
    status Refinery::Employees::XeroExpenseClaim::STATUS_NOT_SUBMITTED
    description 'Expenses'


    factory :xero_expense_claim_with_receipts do

      transient do
        no_of_receipts 1
      end

      after(:create) do |xero_expense_claim, evaluator|
        FactoryGirl.create_list(:xero_receipt, evaluator.no_of_receipts, xero_expense_claim: xero_expense_claim)
      end
    end
  end
end

