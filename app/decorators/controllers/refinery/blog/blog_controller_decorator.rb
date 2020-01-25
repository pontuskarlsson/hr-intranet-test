Refinery::Blog::BlogController.class_eval do
  layout 'public'

  def redirect_domain
    unless WWWSubdomain.matches? request
      redirect_to "#{request.protocol}#{WWWSubdomain.domain}#{request.fullpath}"
    end
  end

end
