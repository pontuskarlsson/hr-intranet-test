FactoryBot.define do
  factory :authentication_devise_user, class: Refinery::Authentication::Devise::User do
    sequence(:email) { |n| "john-#{n}@doe.com" }
    sequence(:username) { |n| "john-#{n}" }
    password { 'demo_password' }
    password_confirmation { |u| u.password }

    full_name { 'John Doe' }
  end
end
