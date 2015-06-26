Refinery::Admin::PagesController.class_eval do

  before_filter :find_available_roles,  :only => [:new, :create, :edit, :update]
  before_filter :extract_roles,         :only => [:create, :update]


  protected
  def find_available_roles
    @available_roles = Refinery::Role.all
  end

  def user_can_assign_roles?
    Refinery::Authentication.superuser_can_assign_roles &&
        current_refinery_user.has_role?(:superuser)
  end

  def extract_roles
    # Store what the user selected.
    @selected_role_names = params[:page].delete(:roles) || []
    @selected_role_names = @page.roles.select(:title).map(&:title) unless user_can_assign_roles?

    @page.roles = @selected_role_names.map { |r| Refinery::Role[r.downcase] }
  end

end