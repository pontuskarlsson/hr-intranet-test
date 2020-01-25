class HomeController < ApplicationController
  layout 'public'

  before_action :redirect_external, except: [:legal, :index]
  before_action :find_page

  skip_before_action :authenticate_authentication_devise_user!, only: [:index, :legal]

  def index
    if restrict_public_pages?
      render template: 'refinery/launching_soon'
    else
      template = @page&.link_url == "/" ? "home" : "show"
      render template: "refinery/pages/#{@page&.view_template.presence || template}"
    end
  end

  def sections
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def legal
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  private

  def redirect_external
    unless current_authentication_devise_user && current_authentication_devise_user.has_role?(Refinery::Employees::ROLE_EMPLOYEE)
      redirect_to portal_root_url
    end
  end

  def redirect_domain
    unless WWWSubdomain.matches? request
      if params[:action] == 'index' && PortalSubdomain.matches?(request)
        redirect_to portal_root_url
      else
        redirect_to "#{request.protocol}#{WWWSubdomain.domain}#{request.fullpath}"
      end
    end
  end

  def find_page
    url = request.original_fullpath.chomp('/')
    url = '/' if url.blank?
    @page = ::Refinery::Page.find_by_link_url(url)
    not_found unless @page.present?
  end

end
