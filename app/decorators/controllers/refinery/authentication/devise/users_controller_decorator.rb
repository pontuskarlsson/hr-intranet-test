Refinery::Authentication::Devise::UsersController.class_eval do
  #layout 'public'

  skip_before_action :authenticate_authentication_devise_user!

  helper_method :active_tab

  def new
    @sign_up_form = SignUpForm.new
  end

  # Overriding so that create action does not user +create_first+ which grants admin access
  def create
    @sign_up_form = SignUpForm.new(sign_up_form_params)

    if @sign_up_form.save
      flash[:message] = t('welcome', scope: 'refinery.authentication.devise.users.create', who: @sign_up_form.user)

      sign_in(@sign_up_form.user)
      redirect_back_or_default(portal_root_url)

      ErrorMailer.notification_email('New user signup').deliver_later

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

  def sign_up_form_params(allowed = %i(company_name first_name last_name email password password_confirmation))
    params.require(:sign_up_form).permit(allowed)
  end

  # For login form
  def resource
    @user ||= Refinery::Authentication::Devise::User.new
  end

  def active_tab
    'sign_up'
  end

end
