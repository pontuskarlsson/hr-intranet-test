
FactoryGirl.define do
  factory :calendar, :class => Refinery::Calendar::Calendar do
    user nil
    sequence(:title) { |n| "refinery#{n}" }
    function nil
    self.private false
  end
end

