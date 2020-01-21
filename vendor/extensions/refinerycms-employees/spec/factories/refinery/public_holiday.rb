
FactoryBot.define do
  factory :public_holiday, :class => Refinery::Employees::PublicHoliday do
    sequence(:title) { |n| "Holiday ##{n}" }
    sequence(:holiday_date) { |n| Date.today + n.day }
    country { ::Refinery::Employees::Countries::COUNTRIES.first }
  end
end

