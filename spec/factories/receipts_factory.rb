FactoryGirl.define do
  factory :receipt do
    expense_claim
    contact
    user { |receipt| receipt.expense_claim.user }
    total 99
  end
end
