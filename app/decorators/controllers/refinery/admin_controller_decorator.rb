Refinery::AdminController.class_eval do

  before_filter :set_user_time_zone

  private
  def set_user_time_zone
    Time.zone = 'Hong Kong'
  end

end
