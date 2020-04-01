FactoryBot.define do
  factory :voucher, :class => Refinery::Business::Voucher do
    association :company, factory: :verified_company
    association :article, factory: :article_voucher
    discount_type { 'fixed_amount' }
    base_amount { |evaluator| evaluator.article&.sales_unit_price }
    discount_amount { 0.0 }
    source { 'invoice' }

    transient do
      invoice_purchase { |evaluator| FactoryBot.create(:invoice, evaluator.article.account) }
    end

    line_item_prepay_in { |evaluator| FactoryBot.create(:invoice_item_prepay_in, invoice: evaluator.invoice_purchase, unit_amount: evaluator.base_amount) }
    valid_from { |evaluator| evaluator.invoice_purchase.invoice_for_month || evaluator.invoice_purchase.invoice_date }
    valid_to { |evaluator| evaluator.valid_from + 1.year - 1.day }

  end
end
