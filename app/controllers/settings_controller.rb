class SettingsController < ApplicationController
  before_action :find_company

  helper_method :invite_form

  def show

  end

  def update
    if @company.update_attributes(company_params)
      redirect_to setting_path(@company)
    else
      render action: :show
    end
  end

  def invite
    respond_to do |format|
      if invite_form.save
        format.html { redirect_to setting_path(@company, anchor: 'settings-users') }
        # New empty form
        format.js { @invite_form = InviteForm.new_in_model(@company, {}, current_refinery_user) }
      else
        format.html { render action: :show }
        format.js
      end
    end
  end

  private

  def company_scope
    @companies ||= ::Refinery::Business::Company.for_user_roles(current_refinery_user)
  end

  def find_company
    @company = company_scope.find(params[:id])
  rescue ::ActiveRecord::RecordNotFound
    error_404
  end

  def company_params
    params.require(:company).permit(:name)
  end

  def invite_form_params
    params.require(:invite_form).permit(:email, :first_name, :last_name, :role)
  end

  def invite_form
    @invite_form ||= InviteForm.new_in_model(@company, params[:invite_form], current_refinery_user)
  end

end
