Refinery::SitemapController.class_eval do

  before_action :redirect_domain

  private
  def redirect_domain
    unless WWWSubdomain.matches? request
      redirect_to "#{request.protocol}#{WWWSubdomain.domain}#{request.fullpath}"
    end
  end

end
