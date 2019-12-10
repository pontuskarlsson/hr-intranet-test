# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryBot.define do
  factory :user_setting do
    association :user, factory: :authentication_devise_user
    identifier { "MyString" }
    content { {} }
  end
end
