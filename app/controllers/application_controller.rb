class ApplicationController < ActionController::Base
  include Portal::Wizard::ActionController
  helper Portal::Wizard::Helper

  def self.protect_from_forgery(options = {})
    #super options.merge(prepend: true, with: :null_session)
  end

  protect_from_forgery unless: -> { oauth? }

  before_action :redirect_domain
  before_action :authenticate_authentication_devise_user!

  before_action :set_user_time_zone

  helper_method :filter_params, :header_menu_pages, :home_page_url, :is_home_page?, :restrict_public_pages?, :login_url

  # Workaround to avoid problem with user accessing other
  # engines while password is expired.
  delegate :authentication_devise_user_password_expired_path, :root_path, to: :refinery

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
    "#{request.protocol}#{WWWSubdomain.domain}"
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
      portal_root_url
    else
      session[:authentication_devise_user_return_to]
    end
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # def current_user
  #   current_resource_owner
  # end

  def oauth?
    false
  end

  def home_page_url
    '/'
  end

  def is_home_page?
    request.original_fullpath.chomp == home_page_url
  end

  def header_menu_pages
    Refinery::Page.find_by_link_url(home_page_url)&.children || []
  end

  def restrict_public_pages?
    false # current_authentication_devise_user.nil? || !current_authentication_devise_user.has_role?(Refinery::Employees::ROLE_EMPLOYEE)
  end

  def login_url
    "#{request.protocol}#{PortalSubdomain.domain}"
  end

  def portal_root_url
    "#{request.protocol}#{PortalSubdomain.domain}/dashboard"
  end

  private
  def redirect_domain
    unless PortalSubdomain.matches? request
      redirect_to "#{request.protocol}#{PortalSubdomain.domain}#{request.fullpath}"
    end
  end

  def set_user_time_zone
    Time.zone = 'Hong Kong'
  end

end
