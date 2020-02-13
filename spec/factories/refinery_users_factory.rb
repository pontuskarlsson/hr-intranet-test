# Copying the factories from refinerycms-authentication-devise module here. The first reason for that
# is that the factory_paths in the module is not correct on the 2.0.0 release (fixed on master branch though).
# Bt I also want a full_name attribute on it.
#
FactoryBot.define do
  factory :authentication_devise_user, :class => Refinery::Authentication::Devise::User do
    sequence(:username) { |n| "refinery#{n}" }
    sequence(:email) { |n| "refinery#{n}@example.com" }
    password  "refinerycms"
    password_confirmation "refinerycms"

    full_name { 'Refinery CMS' }

    factory :authentication_devise_user_with_roles do
      transient do
        role_titles []
      end

      after(:create) do |user, evaluator|
        user.roles = evaluator.role_titles.map { |title|
          ::Refinery::Authentication::Devise::Role[title]
        }
      end
    end
  end

  factory :authentication_devise_refinery_user, :parent => :authentication_devise_user do
    roles { [ ::Refinery::Authentication::Devise::Role[:refinery] ] }

    after(:create) do |user|
      ::Refinery::Plugins.registered.each_with_index do |plugin, index|
        user.plugins.create(:name => plugin.name, :position => index)
      end
    end
  end

  factory :authentication_devise_refinery_superuser, :parent => :authentication_devise_refinery_user do
    roles {
      [
          ::Refinery::Authentication::Devise::Role[:refinery],
          ::Refinery::Authentication::Devise::Role[:superuser]
      ]
    }
  end
end