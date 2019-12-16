class HomeController < ApplicationController
  layout 'public'

  before_action :redirect_external, except: [:privacy_policy, :terms_conditions]
  before_action :find_page,         only: %i(about)

  def index

  end

  def services

  end

  def about
    template = @page.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page.view_template.presence || template}"
  end

  def contact

  end

  def journal

  end

  def privacy_policy

  end

  def terms_conditions

  end

  private

  def redirect_external
    unless current_authentication_devise_user.has_role?(Refinery::Employees::ROLE_EMPLOYEE)
      redirect_to refinery.root_path
    end
  end

  def find_page
    @page = ::Refinery::Page.find_by_link_url!('/about')
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
