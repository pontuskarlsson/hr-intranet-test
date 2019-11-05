
FactoryGirl.define do
  factory :billable, :class => Refinery::Business::Billable do
    company
    billable_type 'time'
    title 'QA/QC Jobs'
    qty_unit 'day'


    factory :billable_with_article do
      transient do
        account { |evaluator| evaluator.invoice&.account || FactoryGirl.create(:account) }
      end

      article { |evaluator| FactoryGirl.create(:article, account: evaluator.account) }
    end
  end
end
