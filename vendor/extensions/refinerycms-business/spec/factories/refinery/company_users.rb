FactoryBot.define do
  factory :company_user, :class => Refinery::Business::CompanyUser do
    company
    user { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
        ::Refinery::Business::ROLE_EXTERNAL
    ]) }
    role { 'Manager' }
  end
end
