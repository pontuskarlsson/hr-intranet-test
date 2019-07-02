Refinery::Authentication::Devise::Admin::UsersController.class_eval do

  def user_params
    params.require(:user).permit(
        :email, :password, :password_confirmation, :remember_me, :username,
        :plugins, :login, :full_name, :password_has_expired, :deactivated
    )
  end

end
