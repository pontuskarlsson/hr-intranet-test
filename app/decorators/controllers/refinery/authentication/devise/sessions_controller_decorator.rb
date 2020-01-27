Refinery::Authentication::Devise::SessionsController.class_eval do

  helper_method :active_tab

  def new
    @sign_up_form = SignUpForm.new
    super
  end

  def active_tab
    'login'
  end

end
