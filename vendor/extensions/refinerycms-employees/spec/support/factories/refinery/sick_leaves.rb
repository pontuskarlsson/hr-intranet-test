
FactoryGirl.define do
  factory :sick_leave, :class => Refinery::Employees::SickLeave do
    employee
    start_date '2014-01-10'
  end
end

