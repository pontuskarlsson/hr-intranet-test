class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_refinery_user!

  before_filter :set_user_time_zone

  private
  def set_user_time_zone
    Time.zone = 'Hong Kong'
  end

end
