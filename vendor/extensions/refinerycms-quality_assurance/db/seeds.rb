Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INTERNAL).first_or_create
role_internal_manager = Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER).first_or_create
Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_EXTERNAL).first_or_create
Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INSPECTOR).first_or_create

Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  Refinery::User.find_each do |user|
    user.plugins.where(name: 'refinerycms-quality_assurance').first_or_create!(
      position: (user.plugins.maximum(:position) || -1) +1
    )
  end if defined?(Refinery::User)

  [
      [Refinery::QualityAssurance::PAGE_INSPECTIONS_URL, 'Inspections'],
      [Refinery::QualityAssurance::PAGE_JOBS_URL, 'Jobs', role_internal_manager]
  ].each do |url, title, role|

    Refinery::Page.where(link_url: url).first_or_create!(
      title: title,
      deletable: false,
      menu_match: "^#{url}(\/|\/.+?|)$"
    ) do |page|
      Refinery::Pages.default_parts.each_with_index do |part, index|
        page.parts.build title: part[:title], slug: part[:slug], body: nil, position: index
      end

      page.roles << role if role
    end if defined?(Refinery::Page)

  end
end
