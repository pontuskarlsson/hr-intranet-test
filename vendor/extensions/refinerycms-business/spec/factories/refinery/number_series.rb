FactoryBot.define do
  factory :number_serie, :class => Refinery::Business::NumberSerie do
    identifier { 'Refinery::Business::Company#code' }
  end
end
