Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  if defined?(Refinery::User)
    Refinery::User.all.each do |user|
      if user.plugins.where(:name => 'refinerycms-employees').blank?
        user.plugins.create(:name => 'refinerycms-employees',
                            :position => (user.plugins.maximum(:position) || -1) +1)
      end
    end
  end

  url = "/employees"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :title => 'Employees',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/employees/employees"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
      :parent_id => Refinery::Page.where(:link_url => '/employees').first.try(:id),
      :title => 'Employee Directory',
      :link_url => url,
      :deletable => false,
      :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/employees/sick_leaves"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/employees').first.try(:id),
        :title => 'Sick Leave',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/employees/annual_leaves"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/employees').first.try(:id),
        :title => 'Annual Leave',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/employees/expense_claims"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/employees').first.try(:id),
        :title => 'Expense Claims',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end

  url = "/employees/all_leave_of_absences"
  if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
    page = Refinery::Page.create(
        :parent_id => Refinery::Page.where(:link_url => '/employees').first.try(:id),
        :title => 'All Leave Of Absences',
        :link_url => url,
        :deletable => false,
        :menu_match => "^#{url}(\/|\/.+?|)$"
    )
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :body => nil, :position => index)
    end
  end
end
