module ApplicationHelper

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

end
