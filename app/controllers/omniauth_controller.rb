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
      current_user.omni_authentications.create!(
          provider: auth_hash.provider,
          uid: auth_hash.uid,
          token: auth_hash.credentials.token,
          token_expires: auth_hash.credentials.expires_at,
          refresh_token: auth_hash.credentials.refresh_token,
          auth_info: auth_hash.info,
          extra: auth_hash.extra
      )
      flash[:notice] = "Authentication successful."
      redirect_to my_profile_path
    else
      #session[:omniauth] = omni.except('extra')
      #redirect_to new_user_registration_path
      flash[:notice] = "User not registered!"
      redirect_to new_user_session_url
    end
  end

end
