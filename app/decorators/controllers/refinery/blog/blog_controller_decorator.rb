Refinery::Blog::BlogController.class_eval do
  layout 'public'

  skip_before_action :authenticate_authentication_devise_user!

  def redirect_domain
    unless WWWSubdomain.matches? request
      redirect_to "#{request.protocol}#{WWWSubdomain.domain}#{request.fullpath}"
    end
  end

end
