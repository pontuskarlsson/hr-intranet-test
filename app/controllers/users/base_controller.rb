module Users::BaseController

  def set_target
    @target = Refinery::Authentication::Devise::User.friendly.find params[:user_id]
  rescue ActiveRecord::RecordNotFound => e
    error_404
  end

  def authenticate_devise_resource!
    authenticate_authentication_devise_user!
  end

  def authenticate_target!
    unless @target == current_authentication_devise_user
      render plain: "403 Forbidden: Unauthorized target", status: 403
    end
  end
end
