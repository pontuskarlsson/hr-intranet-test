Refinery::Authentication::Devise::Admin::UsersController.class_eval do

  def user_params
    params.require(:user).permit(
        :email, :password, :password_confirmation, :remember_me, :username,
        :login, :full_name, :deactivated, :topo_id, plugins: []
    )
  end

end
