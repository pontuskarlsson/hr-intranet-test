role_external = Refinery::Authentication::Devise::Role.where(title: Refinery::Business::ROLE_EXTERNAL).first_or_create
role_internal = Refinery::Authentication::Devise::Role.where(title: Refinery::Business::ROLE_INTERNAL).first_or_create
role_internal_finance = Refinery::Authentication::Devise::Role.where(title: Refinery::Business::ROLE_INTERNAL_FINANCE).first_or_create

Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  if defined?(Refinery::User)
    Refinery::User.all.each do |user|
      if user.plugins.where(:name => 'refinerycms-business').blank?
        user.plugins.create(:name => 'refinerycms-business',
                            :position => (user.plugins.maximum(:position) || -1) +1)
      end
    end
  end

  [
      [Refinery::Business::PAGE_BILLABLES_URL,  'Billables', role_internal_finance, role_internal],
      [Refinery::Business::PAGE_BILLS_URL,      'Bills', role_internal_finance],
      [Refinery::Business::PAGE_BUDGETS_URL,    'Budgets', role_internal_finance],
      [Refinery::Business::PAGE_COMPANIES_URL,  'Companies', role_internal, role_external],
      [Refinery::Business::PAGE_INVOICES_URL,   'Invoices', role_internal_finance],
      [Refinery::Business::PAGE_ORDERS_URL,     'Orders', role_internal_finance],
      [Refinery::Business::PAGE_PROJECTS_URL,   'Projects', role_internal, role_external],
      [Refinery::Business::PAGE_PURCHASES_URL,  'Purchases', role_internal, role_external],
      [Refinery::Business::PAGE_REQUESTS_URL,   'Requests', role_internal, role_external],
      [Refinery::Business::PAGE_SECTIONS_URL,   'Sections', role_internal, role_external]
  ].each do |url, title, *roles|

    if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
      page = Refinery::Page.create(
          :title => title,
          :link_url => url,
          :deletable => false,
          :menu_match => "^#{url}(\/|\/.+?|)$"
      )
      Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
        page.parts.create(:title => default_page_part, :body => nil, :position => index)
      end
      roles.each { |r| page.roles << r  }
    end

  end
end
