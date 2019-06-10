class HomeController < ApplicationController
  layout 'public'

  before_filter :redirect_external

  def index

  end

  def services

  end

  def about

  end

  def contact

  end

  def careers

  end

  def privacy_policy

  end

  def terms_conditions

  end

  private

  def redirect_external
    unless current_authentication_devise_user.has_role?(Refinery::Employees::ROLE_EMPLOYEE)
      redirect_to refinery.root_path
    end
  end

end
