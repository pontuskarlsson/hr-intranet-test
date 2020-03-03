FactoryBot.define do
  factory :plan, :class => Refinery::Business::Plan do
    account
    association :company, factory: :verified_company
    contact_person { |evaluator|
      FactoryBot.create(:company_user, company: evaluator.company).user
    }
    account_manager { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
        ::Refinery::Business::ROLE_INTERNAL
    ]) }
    sequence(:reference) { |n| "PL#{n.to_s.rjust(5, '0')}" }
    title { 'Monthly Plan' }
    description { 'A description of a monthly plan.' }
    currency_code { ::Refinery::Business::Invoice::CURRENCY_CODES.first }
    status { 'draft' }


    factory :confirmed_plan do
      status { 'confirmed' }
      plan_charges { [
          { qty: '10',
            article_label: FactoryBot.create(:article_voucher).code,
            base_amount: '350',
            discount_amount: '-35',
            discount_type: 'fixed_amount'
          }
      ] }
    end
  end
end
