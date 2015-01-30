
FactoryGirl.define do
  factory :annual_leave, :class => Refinery::Employees::AnnualLeave do
    employee
    start_date '2014-01-20'
  end
end

