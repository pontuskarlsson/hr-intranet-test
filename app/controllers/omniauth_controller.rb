class OmniauthController < ApplicationController
  skip_before_action :authenticate_authentication_devise_user!

  before_action :find_or_create_authentication, only: [:callback]

  def callback
  end

  protected

  def current_user
    current_authentication_devise_user
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def find_or_create_authentication
    authentication = Omni::Authentication.find_by(
        provider: auth_hash.provider,
        uid: auth_hash.uid
    )

    if authentication.present?
      if current_user.nil?
        flash[:notice] = "Logged in Successfully"
        sign_in_and_redirect authentication.user
      else
        flash[:notice] = "Already authenticated with that provider"
        redirect_to my_profile_path
      end

    elsif current_user
      if create_authentication(current_user)
        flash[:notice] = "Authentication successful."
        redirect_to my_profile_path
      else
        flash[:alert] = "Failed to authenticate with that provider."
        redirect_to my_profile_path
      end

    elsif auth_hash.info.&email.present? && (user = ::Refinery::Authentication::Devise::User.find_by(email: auth_hash.info.email)).present?
      if create_authentication(user)
        flash[:notice] = "Authentication successful."
        sign_in_and_redirect user
      else
        flash[:alert] = "Failed to authenticate with that provider."
        redirect_to new_signup_path
      end

    else
      form = OauthSignUpForm.new(auth_hash: auth_hash)
      if form.save
        flash[:notice] = "Registration successful."
        sign_in_and_redirect form.user
      else
        flash[:alert] = "Failed to register from that provider."
        redirect_to new_signup_path
      end
    end
  end

  def create_authentication(user)
    user.omni_authentications.create(
        provider: auth_hash.provider,
        uid: auth_hash.uid,
        token: auth_hash.credentials.token,
        token_expires: auth_hash.credentials.expires_at,
        refresh_token: auth_hash.credentials.refresh_token,
        auth_info: auth_hash.info,
        extra: auth_hash.extra
    )
  end

end
