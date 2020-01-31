module ApplicationHelper

  def dragonfly_reveal_tag(image, width = 190, height = 190, fetch_by_default = true)
    # Create link to open image in a new tab
    external_link = link_to(image.image.url, target: '_blank', class: 'button') do
      content_tag(:span, 'Open in new tab ') + content_tag(:i, '', class: 'fa fa-external-link')
    end

    # Create link to download the image
    download_link = link_to(image.image.url, download: image.image_name, class: 'button') do
      content_tag(:span, 'Download ') + content_tag(:i, '', class: 'fa fa-cloud-download')
    end

    # Create thumbnail
    if fetch_by_default
      thumbnail = image_tag(image.image.thumb("#{width}x#{height}#").url, class: 'dragonfly-thumb-tag', 'data-open' => "preview-image-modal-#{image.id}")
    else
      thumbnail = image_tag('data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D', 'data-src' => image.image.thumb("#{width}x#{height}#").url, class: 'dragonfly-thumb-tag', 'data-open' => "preview-image-modal-#{image.id}")
    end

    # Render and return the resulting modal content and thumnbail
    content_tag(:div, class: 'reveal js-image-reveal', id: "preview-image-modal-#{image.id}", 'data-reveal' => true) do
      content_tag(:div) do
        external_link + ' ' + download_link
      end + image_tag('ajax-loader.gif', 'data-src' => image.image.url, class: 'dragonfly-image-tag')
    end + thumbnail
  end

  def header_menu_items(parent_page = nil)
    if parent_page.present?
      parent_page.children.fast_access_menu Array(current_refinery_user.try(:roles))
    else
      Refinery::Page.roots.fast_access_menu Array(current_refinery_user.try(:roles))
    end
  end

  def header_menu
    presenter = Refinery::Pages::MenuPresenter.new(header_menu_items, self)
    presenter.css = 'top-bar-section'
    presenter.menu_tag = :section
    presenter.selected_css = :active
    presenter
  end

  def foundation_form_field(label, field, errors = [])
    if errors.any?
      "<label class=\"error\">#{label}#{field.html_safe}</label><small class=\"error\">#{ errors.join(', ') }</small>".html_safe
    else
      "<label>#{label}#{field.html_safe}</label>".html_safe
    end
  end

  def format_joined_items(str)
    str.present? ? str.split(',').map(&:squish).join(', ') : ''
  end

  def fa_icon_from_mime_type(resource)
    if resource.file_mime_type.present?
      case resource.file_mime_type
      when /application\/(zip)/ then 'fa-file-archive-o'
      when /application\/(vnd\.openxmlformats-officedocument\.spreadsheetml\.sheet|vnd\.ms-excel)/ then 'fa-file-excel-o'
      when /image\/(jpeg|jpg|png|gif|bmp)/ then 'fa-file-image-o'
      when /application\/(pdf|x-pdf)/ then 'fa-file-pdf-o'
      when /application\/(vnd\.openxmlformats-officedocument\.presentationml\.presentation)/ then 'fa-file-powerpoint-o'
      when /application\/(pdf)/ then 'fa-file-video-o'
      when /application\/(pdf)/ then 'fa-file-word-o'
      else 'fa-file-o'
      end

    else
      case resource.file_name.split('.').last
      when /zip/ then 'fa-file-archive-o'
      when /xls|xlsx/ then 'fa-file-excel-o'
      when /jpeg|jpg|png|gif|bmp/ then 'fa-file-image-o'
      when /pdf/ then 'fa-file-pdf-o'
      when /ppt|pptx/ then 'fa-file-powerpoint-o'
      when /mpg|mpeg|avi|mp4/ then 'fa-file-video-o'
      when /doc|docx|/ then 'fa-file-word-o'
      else 'fa-file-o'
      end
    end
  end

  # This tag is used on the responsive section layouts. Full width refers to
  # the full grid-container width.
  #
  # The maximum grid-container width listed in _settings.scss is 1024px.
  #
  # The XY Grid currently implemented through foundation, is configured for
  # the following widths:
  #
  #   Large >= 1024px > Medium >= 640px > Small >= 0
  #
  # This means that an image dedicated for the Medium layout, will be displayed
  # on screen-widths in the range from 640px to 1023px.
  #
  # That would mean to use 1024px (rounded up from 1023px) width for Medium to
  # reduce image size as much as possible, while still maintaining full image
  # quality. And since the grid will never grow wider than 1024px, regardless
  # of screen width, we can use the same interchange for Medium and up, only
  # keeping a small "mobile" specific size.
  #
  # When it comes to the half grid section, note that it is only half on medium
  # and up, i.e. "cell medium-6". That means on a Small layout, it would still
  # have a maximum of 639px width.
  #
  # For Medium and up however, given that the grid-container is at most 1024px,
  # and that the grid-gutter for medium up is 30px, that means a medium-6 cell
  # can be at most
  #
  def image_interchange_tag(image, width = 'full', options = {})
    if width == 'full'
      dimensions = {
          small: '640',
          medium: '1024',
      }
    elsif width == 'half'

    else
      return image_tag image.url, options
    end

    options['data-interchange'] =
        "[#{image.url(small_dimensions)}, small],"<<
        "[assets/img/interchange/medium.jpg, medium],"<<
        "[assets/img/interchange/large.jpg, large]"
    tag('img', options)
  end

  def method_missing(method_name, *arguments, &block)
    if method_name.to_s =~ /\A(.*)_path\z/ && refinery.respond_to?(method_name)
      refinery.send(method_name, *arguments, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s =~ /\A(.*)_path\z/ && refinery.respond_to?(method_name) || super
  end

end
