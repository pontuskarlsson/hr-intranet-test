
FactoryGirl.define do
  factory :xero_api_key_file, :class => Refinery::Employees::XeroApiKeyfile do
    sequence(:organisation) { |n| "Organisation ##{n}" }
    key_content 'Key Content'
    consumer_key 'Consumer Key'
    consumer_secret 'Consumer Secret'
    encryption_key 'Encryption Key'
  end
end

