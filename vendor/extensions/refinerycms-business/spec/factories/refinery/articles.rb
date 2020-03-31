FactoryBot.define do
  factory :article, :class => Refinery::Business::Article do
    sequence(:code) { |n| "WORK-DAY-#{n}" }
    name { 'Work Man Day' }
    is_sold { true }
    sales_unit_price { 1_000 }
    is_public { |evaluator| evaluator.company.nil? }
    is_managed { true }
    managed_status { 'draft' }

    after(:create) do |article, evaluator|
      unless article.is_discount
        if article.is_voucher
          FactoryBot.create(:article_voucher, account: evaluator.account, code: "#{article.code}-DISC", is_discount: true)
        else
          FactoryBot.create(:article, account: evaluator.account, code: "#{article.code}-DISC", is_discount: true)
        end
      end
    end

    factory :article_voucher do
      name { 'Voucher Man Day' }
      is_voucher { true }
      voucher_constraint_applicable_articles { |evaluator| evaluator.is_discount ? nil : [FactoryBot.create(:article, account: evaluator.account)] }
    end

  end
end
