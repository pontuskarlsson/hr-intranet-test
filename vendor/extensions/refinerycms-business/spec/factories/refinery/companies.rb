FactoryBot.define do
  factory :company, :class => Refinery::Business::Company do
    sequence(:name) { |n| "Amazing #{n} Ltd." }


    factory :verified_company do
      verified_at { '2010-01-01' }
    end
  end
end
