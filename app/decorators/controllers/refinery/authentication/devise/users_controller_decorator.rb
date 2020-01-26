Refinery::Authentication::Devise::UsersController.class_eval do
  #layout 'public'

  skip_before_action :authenticate_authentication_devise_user!

  def new
    @user = Refinery::Authentication::Devise::User.new
  end

  # Overriding so that create action does not user +create_first+ which grants admin access
  def create
    @user = Refinery::Authentication::Devise::User.new(user_params)

    if @user.save
      flash[:message] = t('welcome', scope: 'refinery.authentication.devise.users.create', who: @user)

      sign_in(@user)
      redirect_back_or_default(portal_root_url)
    else
      render :new
    end
  end

  # Overriding so that public sign up is allowed
  def redirect?
    if current_refinery_user.has_role?(:refinery)
      redirect_to refinery.authentication_devise_admin_users_path
    elsif !current_refinery_user.is_a?(Refinery::Authentication::Devise::NilUser)
      redirect_to refinery.login_path
    end
  end

end
