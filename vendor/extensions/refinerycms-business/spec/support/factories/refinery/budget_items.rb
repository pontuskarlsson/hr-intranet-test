
FactoryGirl.define do
  factory :budget_item, :class => Refinery::Business::BudgetItem do
    budget
    sequence(:description) { |n| "refinery#{n}" }
  end
end
