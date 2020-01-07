class HomeController < ApplicationController
  layout 'public'

  before_action :redirect_external, except: [:legal]
  before_action :find_page

  def index
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def services
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def about
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def contact
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def journal

  end

  def resources
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def legal
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  private

  def redirect_external
    unless current_authentication_devise_user.has_role?(Refinery::Employees::ROLE_EMPLOYEE)
      redirect_to refinery.root_path
    end
  end

  def find_page
    @page = ::Refinery::Page.find_by_link_url(request.original_fullpath.chomp('/'))
    not_found unless @page.present?
  end

end
