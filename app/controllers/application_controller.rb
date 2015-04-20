class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_refinery_user!

  before_filter :set_user_time_zone

  # Workaround to avoid problem with user accessing other
  # engines while password is expired.
  delegate :refinery_user_password_expired_path, to: :refinery

  private
  def set_user_time_zone
    Time.zone = 'Hong Kong'
  end

end
