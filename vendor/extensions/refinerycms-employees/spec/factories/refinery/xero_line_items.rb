
FactoryBot.define do
  factory :xero_line_item, :class => Refinery::Employees::XeroLineItem do
    xero_receipt
    xero_account
    description { 'Line Item Description' }
    quantity { 1 }
    unit_amount { 100 }
  end
end

