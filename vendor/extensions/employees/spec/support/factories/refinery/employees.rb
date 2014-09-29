
FactoryGirl.define do
  factory :employee, :class => Refinery::Employees::Employee do
    sequence(:employee_no) { |n| "refinery#{n}" }
  end
end

