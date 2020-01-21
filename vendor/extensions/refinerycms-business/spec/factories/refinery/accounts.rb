FactoryBot.define do
  factory :account, :class => Refinery::Business::Account do
    sequence(:organisation) { |n| "Company #{n}" }

    # Dummy keys
    key_content { '01437185609acf285828db9a044af7bd' }
    consumer_key { 'a44addec9409be73e91e2b149238da66' }
    consumer_secret { '5f3e0e3e46de615efacdc030c628d16b' }
    encryption_key { 'c37107bd19c47eebebd786d7' }
  end
end
