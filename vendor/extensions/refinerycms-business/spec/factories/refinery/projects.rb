FactoryBot.define do
  factory :project, :class => Refinery::Business::Project do
    association :company, factory: :verified_company
  end
end
