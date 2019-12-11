class Api::V1::ApiController < ApplicationController
  skip_before_action :authenticate_authentication_devise_user!
  before_action :doorkeeper_authorize!
  respond_to    :json

  protected

  def oauth?
    true
  end

  # Find the user that owns the access token
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end