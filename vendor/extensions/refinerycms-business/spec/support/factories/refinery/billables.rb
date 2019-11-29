
FactoryGirl.define do
  factory :billable, :class => Refinery::Business::Billable do
    company
    billable_type 'time'
    title 'QA/QC Jobs'
    qty 1
    qty_unit 'day'


    factory :billable_with_article do
      transient do
        account { |evaluator| evaluator.invoice&.account || FactoryGirl.create(:account) }
        article_sales_unit_price 1_234
      end

      article { |evaluator| FactoryGirl.create(:article, account: evaluator.account, sales_unit_price: evaluator.article_sales_unit_price) }
    end
  end
end
