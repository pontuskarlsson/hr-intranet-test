role_internal = Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INTERNAL).first_or_create
role_internal_manager = Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER).first_or_create
role_external = Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_EXTERNAL).first_or_create
Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INSPECTOR).first_or_create
business_ext_role = Refinery::Authentication::Devise::Role.where(title: Refinery::Business::ROLE_EXTERNAL).first

Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  Refinery::User.find_each do |user|
    user.plugins.where(name: 'refinerycms-quality_assurance').first_or_create!(
      position: (user.plugins.maximum(:position) || -1) +1
    )
  end if defined?(Refinery::User)

  [
      [Refinery::QualityAssurance::PAGE_CAUSES_URL, 'Causes', role_internal, role_external],
      [Refinery::QualityAssurance::PAGE_CREDITS_URL, 'Credits', business_ext_role],
      [Refinery::QualityAssurance::PAGE_DASHBOARD_URL, 'Dashboard', role_internal, role_external],
      [Refinery::QualityAssurance::PAGE_DEFECTS_URL, 'Defects', role_internal, role_external],
      [Refinery::QualityAssurance::PAGE_INSPECTIONS_URL, 'Inspections', role_internal, role_external],
      [Refinery::QualityAssurance::PAGE_JOBS_URL, 'Jobs', role_internal, role_external],
      [Refinery::QualityAssurance::PAGE_INSPECTIONS_CALENDAR, 'Calendar', role_internal_manager],
  ].each do |url, title, *roles|
    Refinery::Page.where(link_url: url).first_or_create!(
      title: title,
      deletable: false,
      menu_match: "^#{url}(\/|\/.+?|)$"
    ) do |page|
      Refinery::Pages.default_parts.each_with_index do |part, index|
        page.parts.build title: part[:title], slug: part[:slug], body: nil, position: index
      end
      roles.each { |r| page.roles << r  }
      #page.roles << role if role
    end if defined?(Refinery::Page)

  end
end
