class ApplicationController < ActionController::Base

  # Forcing all communication over SSL
  # def self.force_ssl; super unless Rails.env.development? | Rails.env.test?; end
  # force_ssl

  protect_from_forgery

  before_filter :authenticate_authentication_devise_user!

  before_filter :set_user_time_zone

  helper_method :filter_params

  # Workaround to avoid problem with user accessing other
  # engines while password is expired.
  delegate :authentication_devise_user_password_expired_path, to: :refinery

  def authenticate_authentication_devise_user!
    super && ((current_authentication_devise_user.last_active_at && current_authentication_devise_user.last_active_at > 1.minutes.ago) || current_authentication_devise_user.touch(:last_active_at))
  end

  def signed_in_root_path(resource_or_scope)
    return_to_or_root_path resource_or_scope
  end

  def after_sign_in_path_for(resource_or_scope)
    return_to_or_root_path resource_or_scope
  end

  def after_sign_out_path_for(resource_or_scope)
    refinery.login_path
  end

  def after_update_path_for(resource_or_scope)
    return_to_or_root_path resource_or_scope
  end

  def not_found
    error_404
    #render '404', layout: 'public'
  end

  def filter_params
    {}
  end

  def return_to_or_root_path(resource_or_scope)
    if !session[:authentication_devise_user_return_to] || (session[:authentication_devise_user_return_to][/^\/refinery/] && !resource_or_scope.has_role?(:refinery))
      refinery.root_path
    else
      session[:authentication_devise_user_return_to]
    end
  end

  private
  def set_user_time_zone
    Time.zone = 'Hong Kong'
  end

end
