class Api::V1::CredentialsController < Api::V1::ApiController

  # GET /me.json
  def me
    respond_with current_resource_owner
  end

end
