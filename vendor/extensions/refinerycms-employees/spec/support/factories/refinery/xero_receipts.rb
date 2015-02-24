
FactoryGirl.define do
  factory :xero_receipt, :class => Refinery::Employees::XeroReceipt do
    xero_expense_claim
    employee { |xero_receipt| xero_receipt.xero_expense_claim.employee }
    xero_contact
    status Refinery::Employees::XeroReceipt::STATUS_DRAFT
    total 100
  end
end

