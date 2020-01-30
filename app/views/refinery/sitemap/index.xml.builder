xml.instruct!

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  loc_proc = Proc.new { |page|
    # exclude sites that are external to our own domain.
    if page.url.is_a?(Hash)
      # This is how most pages work without being overriden by link_url
      page_url = page.url.merge({:only_path => false, locale: locale})

    elsif page.url.to_s !~ /^http/
      # handle relative link_url addresses.
      page_url = [request.protocol, request.host_with_port, page.url].join
    end

    # Add XML entry only if there is a valid page_url found above.
    xml.url do
      xml.loc refinery.url_for(page_url)
      xml.lastmod page.updated_at.to_date
    end if page_url.present?

    page.children.in_menu.live.each do |sub_page|
      loc_proc.call(sub_page)
    end
  }

  (Refinery::Page.find_by_link_url('/')&.children || Refinery::Page.where('1=0')).live.in_menu.each do |page|
    loc_proc.call page
  end

  (Refinery::Page.find_by_link_url('/company')&.children || Refinery::Page.where('1=0')).live.in_menu.each do |page|
    loc_proc.call page
  end

  (Refinery::Page.find_by_link_url('/resources')&.children || Refinery::Page.where('1=0')).live.in_menu.each do |page|
    loc_proc.call page
  end

  page = Refinery::Page.find_by_link_url('/legal')
  loc_proc.call page if page.present?

  # @locales.each do |locale|
  #   ::I18n.locale = locale
  # end
end
