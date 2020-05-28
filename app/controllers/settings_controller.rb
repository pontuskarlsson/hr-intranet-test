class SettingsController < ApplicationController
  before_action :find_company

  helper_method :invite_form, :company_billing_form, :company_contact_form

  def show

  end

  def update
    if settings_form_saved?
      ErrorMailer.notification_email("Company settings updated for #{@company.code}", params.to_unsafe_h.to_hash).deliver_later
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

  def settings_form_saved?
    if params[:update_billing]
      company_billing_form.save

    else
      company_billing_form.save
    end
  end

  def invite_form
    @invite_form ||= InviteForm.new_in_model(@company, params[:invite_form], current_refinery_user)
  end

  def company_billing_form
    @company_billing_form ||= ::Refinery::Business::CompanyBillingForm.new_in_model(@company, params[:company], current_refinery_user)
  end

  def company_contact_form
    @company_contact_form ||= CompanyContactForm.new_in_model(@company.contact, params[:company_contact_form], current_refinery_user)
  end

end
