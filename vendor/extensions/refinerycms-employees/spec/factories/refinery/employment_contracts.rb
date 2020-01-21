
FactoryBot.define do
  factory :employment_contract, :class => Refinery::Employees::EmploymentContract do
    employee
    start_date { '2014-01-01' }
    vacation_days_per_year { 10 }
    country ::Refinery::Employees::Countries::COUNTRIES.first
  end
end

