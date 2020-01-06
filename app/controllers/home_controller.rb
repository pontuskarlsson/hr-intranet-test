class HomeController < ApplicationController
  layout 'public'

  before_action :redirect_external, except: [:privacy_policy, :terms_conditions]
  before_action :find_page,         except: [:privacy_policy, :terms_conditions]

  def index
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def services
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  def about

  end

  def contact

  end

  def journal

  end

  def resources

  end

  def legal

  end

  private

  def redirect_external
    unless current_authentication_devise_user.has_role?(Refinery::Employees::ROLE_EMPLOYEE)
      redirect_to refinery.root_path
    end
  end

  def find_page
    @page = ::Refinery::Page.find_by_link_url(request.original_fullpath)
  rescue ActiveRecord::RecordNotFound
    not_found
  end

end
