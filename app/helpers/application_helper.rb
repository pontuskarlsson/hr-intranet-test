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

  def header_menu_items
    Refinery::Menu.new(Refinery::Page.fast_access_menu(current_refinery_user.try(:roles) || []))
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

end
