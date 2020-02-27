
FactoryBot.define do
  factory :landing_page, :class => Refinery::Marketing::LandingPage do
    sequence(:title) { |n| "Landing Page Title #{n}" }
    slug { |evaluator| "/#{evaluator.title.downcase.gsub(' ', '_')}" }
  end
end

