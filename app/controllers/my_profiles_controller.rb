class MyProfilesController < ApplicationController

  before_filter :find_page

  def show
    present(@page)
  end

  def update
    if current_refinery_user.update_attributes(valid_attributes)
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

  def valid_attributes(valid = %w(full_name user_settings_attributes))
    params[:user].reject { |k,_| !valid.include?(k) }
  end

end
