class PortalController < ApplicationController
  before_action :find_page

  def dashboard
    template = @page&.link_url == "/" ? "home" : "show"
    render template: "refinery/pages/#{@page&.view_template.presence || template}"
  end

  private

  def find_page
    @page = ::Refinery::Page.find_by_link_url(request.original_fullpath.chomp('/'))
    not_found unless @page.present?
  end

end
