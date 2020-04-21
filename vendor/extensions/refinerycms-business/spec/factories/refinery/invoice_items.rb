FactoryBot.define do
  factory :invoice_item, :class => Refinery::Business::InvoiceItem do
    invoice
    description { 'blank' }


    factory :invoice_item_prepay_in do
      transaction_type { 'prepay_in' }
      article { |evaluator| FactoryBot.create(:article_voucher, account: evaluator.invoice.account) }
      unit_amount { |evaluator| evaluator.article.sales_unit_price }
      quantity { 1.0 }

      factory :invoice_item_prepay_in_with_voucher do
        after(:create) do |invoice_item, evaluator|
          invoice_item.quantity.to_i.times do
            FactoryBot.create(:voucher, company: evaluator.invoice.company, article: evaluator.article, line_item_prepay_in: invoice_item)
          end
        end
      end

      factory :invoice_item_prepay_in_with_redeemed_voucher do
        after(:create) do |invoice_item, evaluator|
          invoice_item.quantity.to_i.times do
            FactoryBot.create(:redeemed_voucher, company: evaluator.invoice.company, article: evaluator.article, line_item_prepay_in: invoice_item)
          end
        end
      end
    end

    factory :invoice_item_prepay_out do
      transaction_type { 'prepay_out' }
      unit_amount { -100.0 }
      quantity { 1.0 }
    end

    factory :invoice_item_prepay_discount_in do
      transaction_type { 'prepay_discount_in' }
      unit_amount { -10.0 }
      quantity { 1.0 }
    end

    factory :invoice_item_prepay_discount_out do
      transaction_type { 'prepay_discount_out' }
      unit_amount { 10.0 }
      quantity { 1.0 }
    end

    factory :invoice_item_sales_purchase do
      transaction_type { 'sales_purchase' }
      article { |evaluator| FactoryBot.create(:article, account: evaluator.invoice.account) }
      unit_amount { |evaluator| evaluator.article.sales_unit_price }
      quantity { 1.0 }
    end

    factory :invoice_item_sales_discount do
      transaction_type { 'sales_discount' }
      unit_amount { -10.0 }
      quantity { 1.0 }
    end
  end
end
