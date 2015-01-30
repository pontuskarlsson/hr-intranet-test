
FactoryGirl.define do
  factory :xero_expense_claim, :class => Refinery::Employees::XeroExpenseClaim do
    employee
    description "Expenses"
  end
end

