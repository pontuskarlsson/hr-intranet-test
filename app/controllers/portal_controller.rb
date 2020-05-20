class PortalController < ApplicationController
  before_action :find_page

  helper_method :recent_requests, :has_multiple_companies?

  def dashboard
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  private

  def find_page
    @page = ::Refinery::Page.find_by_link_url(request.original_fullpath.chomp('/'))
    not_found unless @page.present?
  end

  def requests_scope
    ::Refinery::Business::Request.for_selected_company(selected_company).for_user_roles(current_refinery_user)
  end

  def recent_requests(limit = 5)
    requests_scope.order(request_date: :desc).limit(limit)
  end

  def has_multiple_companies?
    @has_multiple_companies ||= ::Refinery::Business::Company.for_user_roles(current_refinery_user).count > 1
  end

end
