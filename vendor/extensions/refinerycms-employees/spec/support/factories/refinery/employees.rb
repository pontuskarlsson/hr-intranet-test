
FactoryGirl.define do
  factory :employee, :class => Refinery::Employees::Employee do
    sequence(:employee_no) { |n| n }
    sequence(:full_name) { |n| "John Doe ##{n}" }
  end
end

