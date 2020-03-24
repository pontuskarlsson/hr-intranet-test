
FactoryBot.define do
  factory :link, :class => Refinery::Marketing::Link do
    association :contact, factory: :contact
    linked { |evaluator| FactoryBot.create(:address, owner: evaluator.contact.owner) }
    relation { 'mail' }
  end
end

