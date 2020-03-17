FactoryBot.define do
  factory :request, :class => Refinery::Business::Request do
    company
    requested_by { |evaluator|
      user = FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
          ::Refinery::Business::ROLE_EXTERNAL
      ])
      FactoryBot.create(:company_user, company: evaluator.company, user: user)
      user
    }
    created_by { |evaluator| evaluator.requested_by }

    request_type { 'inspection' }
    status { 'requested' }
    subject { 'Inspection Request' }
    description { 'Please get back to me.' }
  end
end
