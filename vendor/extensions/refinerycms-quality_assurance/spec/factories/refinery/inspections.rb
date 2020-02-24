FactoryBot.define do
  factory :inspection, :class => Refinery::QualityAssurance::Inspection do
    association :company, factory: :verified_company
    association :supplier, factory: :verified_company
    association :manufacturer, factory: :verified_company

    result { 'Pass' }
    inspection_date { '2001-01-01' }
    inspection_type { 'Final' }
    inspected_by_name { 'Sir James Doe' }
    po_number { 'PO-001' }
    po_type { 'Bulk' }
    po_qty { 1_000 }
    product_code { '001' }
    product_description { 'T-Shirt' }
    product_colour_variants { 'Black' }
    inspection_standard { 'AQL' }
  end
end

