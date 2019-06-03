Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  Refinery::User.find_each do |user|
    user.plugins.where(name: 'refinerycms-quality_assurance').first_or_create!(
      position: (user.plugins.maximum(:position) || -1) +1
    )
  end if defined?(Refinery::User)

  [
      [Refinery::QualityAssurance::PAGE_DASHBOARD_URL, 'Quality Assurance'],
      [Refinery::QualityAssurance::PAGE_INSPECTIONS_URL, 'Inspections']
  ].each do |url, title|

    Refinery::Page.where(link_url: url).first_or_create!(
      title: title,
      deletable: false,
      menu_match: "^#{url}(\/|\/.+?|)$"
    ) do |page|
      Refinery::Pages.default_parts.each_with_index do |part, index|
        page.parts.build title: part[:title], slug: part[:slug], body: nil, position: index
      end
    end if defined?(Refinery::Page)

  end
end

Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_INTERNAL).first_or_create
Refinery::Authentication::Devise::Role.where(title: Refinery::QualityAssurance::ROLE_EXTERNAL).first_or_create
