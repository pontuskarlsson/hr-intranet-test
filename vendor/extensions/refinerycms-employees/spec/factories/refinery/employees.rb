
FactoryBot.define do
  factory :employee, :class => Refinery::Employees::Employee do
    sequence(:employee_no) { |n| n }
    sequence(:full_name) { |n| "John Doe ##{n}" }

    factory :employee_with_contract do
      after(:create) do |employee, evaluator|
        FactoryBot.create(:employment_contract, employee: employee)
      end
    end
  end
end

