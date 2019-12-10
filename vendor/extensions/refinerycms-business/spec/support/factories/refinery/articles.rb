
FactoryGirl.define do
  factory :article, :class => Refinery::Business::Article do
    sequence(:code) { |n| "WORK-DAY-#{n}" }
    name { 'Work Man Day' }
    is_sold { true }
    sales_unit_price { 1_000 }
    is_public { |evaluator| evaluator.company.nil? }
    is_managed { true }
    managed_status { 'draft' }

    factory :article_voucher do
      is_voucher { true }
    end

  end
end
