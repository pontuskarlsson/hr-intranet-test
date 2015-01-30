
FactoryGirl.define do
  factory :employee, :class => Refinery::Employees::Employee do
    sequence(:employee_no) { |n| n }
    full_name 'John Doe'
  end
end

