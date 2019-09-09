module ApplicationHelper

  def dragonfly_reveal_tag(image, width = 190, height = 190)
    content_tag(:div, class: 'reveal', id: "preview-image-modal-#{image.id}", 'data-reveal' => true) do
      content_tag(:div) do
        link_to(image.image.url, target: '_blank', class: 'button') do
          content_tag(:span, 'Open in new tab ') + content_tag(:i, '', class: 'fa fa-external-link')
        end + ' ' + link_to(image.image.url, download: image.image_name, class: 'button') do
        content_tag(:span, 'Download ') + content_tag(:i, '', class: 'fa fa-cloud-download')
      end
      end + image_tag('data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D', 'data-src' => image.image.url, class: 'dragonfly-image-tag')
    end + image_tag(image.image.thumb("#{width}x#{height}#").url, class: 'dragonfly-thumb-tag', 'data-open' => "preview-image-modal-#{image.id}")
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
