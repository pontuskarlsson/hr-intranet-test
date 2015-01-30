Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  if defined?(Refinery::User)
    Refinery::User.all.each do |user|
      if user.plugins.where(:name => 'refinerycms-marketing').blank?
        user.plugins.create(:name => 'refinerycms-marketing',
                            :position => (user.plugins.maximum(:position) || -1) +1)
      end
    end
  end

  url = "/marketing"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :title => 'Marketing',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/marketing/brands"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
      :parent_id => Refinery::Page.where(:link_url => '/marketing').first.try(:id),
      :title => 'Brands',
      :link_url => url,
      :deletable => false,
      :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/marketing/contacts"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/marketing').first.try(:id),
        :title => 'Contacts',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end
end
