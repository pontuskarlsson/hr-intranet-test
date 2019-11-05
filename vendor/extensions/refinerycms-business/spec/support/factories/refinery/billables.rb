
FactoryGirl.define do
  factory :billable, :class => Refinery::Business::Billable do
    company
    billable_type 'time'
    title 'QA/QC Jobs'
    qty_unit 'day'


    factory :billable_with_article do
      article
    end
  end
end
