Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  if defined?(Refinery::User)
    Refinery::User.all.each do |user|
      if user.plugins.where(:name => 'refinerycms-store').blank?
        user.plugins.create(:name => 'refinerycms-store',
                            :position => (user.plugins.maximum(:position) || -1) +1)
      end
    end
  end

  url = '/store'
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :title => 'Store',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = '/store/orders'
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
      :parent_id => Refinery::Page.where(:link_url => '/store').first.try(:id),
      :title => 'Orders',
      :link_url => url,
      :deletable => false,
      :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = '/store/cart'
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/store').first.try(:id),
        :title => 'Cart',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = '/store/products'
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/store').first.try(:id),
        :title => 'Products',
        :link_url => url,
        :show_in_menu => false,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

end
