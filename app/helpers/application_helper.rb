module ApplicationHelper

  def header_menu_items
    Refinery::Menu.new(Refinery::Page.fast_menu)
  end

  def header_menu
    presenter = Refinery::Pages::MenuPresenter.new(header_menu_items, self)
    presenter.css = 'top-bar-section'
    presenter.menu_tag = :section
    presenter.selected_css = :active
    presenter
  end

end
