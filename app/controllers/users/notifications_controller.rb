class Users::NotificationsController < ActivityNotification::NotificationsController
  before_filter :authenticate_authentication_devise_user!

  # GET /:target_type/:target_id/notifications
  # def index
  #   super
  # end

  # POST /:target_type/:target_id/notifications/open_all
  # def open_all
  #   super
  # end

  # GET /:target_type/:target_id/notifications/:id
  # def show
  #   super
  # end

  # DELETE /:target_type/:target_id/notifications/:id
  # def destroy
  #   super
  # end

  # POST /:target_type/:target_id/notifications/:id/open
  # def open
  #   super
  # end

  # GET /:target_type/:target_id/notifications/:id/move
  # def move
  #   super
  # end

  # No action routing
  # This method needs to be public since it is called from view helper
  # def target_view_path
  #   super
  # end

  # protected

  def set_target
    @target = Refinery::Authentication::Devise::User.friendly.find params[:user_id]
    error_404 unless @target == current_authentication_devise_user
  rescue ActiveRecord::RecordNotFound => e
    error_404
  end

  # def set_notification
  #   super
  # end

  def set_index_options
    super
    @index_options[:limit] = [@index_options[:limit], 100].reject(&:nil).min
    @index_options
  end

  # def load_index
  #   super
  # end

  # def controller_path
  #   super
  # end

  # def set_view_prefixes
  #   super
  # end

  # def return_back_or_ajax
  #   super
  # end
end