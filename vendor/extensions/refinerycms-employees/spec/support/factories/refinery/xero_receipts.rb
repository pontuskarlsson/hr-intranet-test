
FactoryGirl.define do
  factory :xero_receipt, :class => Refinery::Employees::XeroReceipt do
    xero_expense_claim
    employee { |xero_receipt| xero_receipt.xero_expense_claim.employee }
    xero_contact
    status Refinery::Employees::XeroReceipt::STATUS_DRAFT
    total 100


    factory :xero_receipt_with_line_items do

      transient do
        no_of_line_items 1
      end

      after(:create) do |xero_receipt, evaluator|
        FactoryGirl.create_list(:xero_line_item, evaluator.no_of_line_items, xero_receipt: xero_receipt)

        xero_receipt.total = xero_receipt.xero_line_items.inject(0) { |sum, li| sum += li.line_total }
        xero_receipt.xero_expense_claim.total = xero_receipt.xero_expense_claim.xero_receipts(true).inject(0) { |sum, rec| sum += rec.total }
      end
    end
  end
end

