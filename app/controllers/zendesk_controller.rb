class ZendeskController < ApplicationController
  before_action :spam_filter, only: [:submit]
  before_action :validate_params, only: [:submit]

  #skip_before_action :authenticate_authentication_devise_user!

  def submit
    Delayed::Job.enqueue(Portal::Zendesk::SubmitTicketJob.new(params[:name], params[:email], 'Get in touch', params[:message]))
    flash[:notice] = 'Thank you for reaching out to us. We will be in touch shortly.'

    redirect_to root_path
  end

  private

  def spam_filter
    # Spam control, the field :email2 is hidden and would only ever be filled out by a bot
    redirect_to root_path if params[:email2].present?
  end

  def ticket_params
    params.require([:name, :email, :message])
  end

  def validate_params
    ticket_params
  rescue ActionController::ParameterMissing => e
    flash[:alert] = e.message
    redirect_to request.referrer
  end
end
