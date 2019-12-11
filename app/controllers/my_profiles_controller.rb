class MyProfilesController < ApplicationController

  before_action :find_page

  def show
    @applications = ::Doorkeeper::Application.authorized_for(current_refinery_user)

    present(@page)
  end

  def update
    if current_refinery_user.update_attributes(user_params)
      flash[:notice] = 'Successfully updated profile settings'
      redirect_to my_profile_path
    else
      present(@page)
      render action: :show
    end
  end

  private

  def find_page
    @page = ::Refinery::Page.where(link_url: '/my_profile').first
  end

  def user_params
    params.require(:user).permit(:full_name)
  end

end
