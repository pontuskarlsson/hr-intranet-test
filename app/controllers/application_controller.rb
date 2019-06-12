class ApplicationController < ActionController::Base

  # Forcing all communication over SSL
  def self.force_ssl; super unless Rails.env.development? | Rails.env.test?; end
  force_ssl

  protect_from_forgery

  before_filter :authenticate_authentication_devise_user!

  before_filter :set_user_time_zone

  # Workaround to avoid problem with user accessing other
  # engines while password is expired.
  delegate :authentication_devise_user_password_expired_path, to: :refinery

  def signed_in_root_path(resource_or_scope)
    refinery.root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    refinery.login_path
  end

  def not_found
    error_404
    #render '404', layout: 'public'
  end

  private
  def set_user_time_zone
    Time.zone = 'Hong Kong'
  end

end
