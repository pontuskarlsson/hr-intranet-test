FactoryBot.define do
  factory :page_role, :class => Refinery::PageRoles::PageRole do
    page
    role
  end
end
