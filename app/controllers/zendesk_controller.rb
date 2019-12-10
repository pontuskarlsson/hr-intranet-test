class ZendeskController < ApplicationController
  before_action :spam_filter, only: [:submit]

  #skip_before_action :authenticate_authentication_devise_user!

  def submit
    @submitter = Portal::Zendesk::Submitter.new(params[:name], params[:email], 'Get in touch', params[:message])
    if @submitter.submit!
      flash[:notice] = 'Thank you for reaching out to us. We will be in touch shortly.'
    else
      flash[:alert] = 'Sorry, but we could not submit your request at this moment. Please contact us directly by sending an email to info@happyrabbit.com'
    end

    redirect_to root_path
  end

  private

  def spam_filter
    # Spam control, the field :email2 is hidden and would only ever be filled out by a bot
    redirect_to root_path if params[:email2].present?
  end
end
