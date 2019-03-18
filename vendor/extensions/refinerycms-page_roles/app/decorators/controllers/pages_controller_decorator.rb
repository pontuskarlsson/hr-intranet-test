Refinery::Admin::PagesController.class_eval do

  before_filter :find_available_roles,  :only => [:new, :create, :edit, :update]
  before_filter :extract_roles,         :only => [:create, :update]


  protected
  def find_available_roles
    @available_roles = ::Refinery::Authentication::Devise::Role.all
  end

  def user_can_assign_roles?
    Refinery::Authentication::Devise.superuser_can_assign_roles &&
        current_authentication_devise_user.has_role?(:superuser)
  end

  def extract_roles
    # Store what the user selected.
    @selected_role_names = params[:page].delete(:roles) || []
    @selected_role_names = @page.roles.select(:title).map(&:title) unless user_can_assign_roles?

    # When a Page is first created, @page is nil when this method is called. So for now, the roles
    # needs to be set in an update after the Page has been created.
    @page.roles = @selected_role_names.map { |r| ::Refinery::Authentication::Devise::Role[r.downcase] } unless @page.nil?
  end

end