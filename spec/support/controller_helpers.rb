module ControllerHelpers

  def current_user
    if (key = @request.env['rack.session']['warden.user.refinery_user.key']).present?
      @user ||= Refinery::User.find key[0][0]
    end
  end

end
