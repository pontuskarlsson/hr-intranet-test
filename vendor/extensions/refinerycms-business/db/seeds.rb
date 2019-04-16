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
      ['/business/budgets', 'Budgets'],
      ['/business/companies', 'Companies'],
      ['/business/projects', 'Projects'],
      ['/business/sales_orders', 'Sales Orders'],
      ['/business/sections', 'Sections']
  ].each do |url, title|

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
    end

  end

  Refinery::Authentication::Devise::Role.where(title: Refinery::Business::ROLE_EXTERNAL).first_or_create
  Refinery::Authentication::Devise::Role.where(title: Refinery::Business::ROLE_INTERNAL).first_or_create

end
