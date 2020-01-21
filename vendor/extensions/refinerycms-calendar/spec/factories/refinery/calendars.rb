
FactoryBot.define do
  factory :calendar, :class => Refinery::Calendar::Calendar do
    sequence(:title) { |n| "refinery#{n}" }
    self.private { false }
  end
end

