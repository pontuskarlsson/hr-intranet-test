require 'wip_schedule'

class HooksController < ApplicationController
  before_action :verify_hook,             only: %i(catch)
  before_action :doorkeeper_authorize!,   except: %i(catch)
  before_action :ignore_test_requests,    only: %i(create)

  skip_before_action :verify_authenticity_token, :authenticate_authentication_devise_user!

  def create
    rest_hook = current_resource_owner.rest_hooks.build(hook_params)
    if rest_hook.save
      # The Zapier documentation says to return 201 - Created.
      render json: rest_hook.to_json(only: :id), status: :created
    else
      head :forbidden
    end

  rescue StandardError => e
    ErrorMailer.webhook_notification_email(['Create HOOK', e.message], params).deliver
    head :forbidden
  end

  def destroy
    hook = current_resource_owner.rest_hooks.find(params[:id]) if params[:id] && params[:id] != 'not_an_id'
    hook = current_resource_owner.rest_hooks.find_by(hook_url: params[:hook_url]).destroy if hook.nil? && params[:hook_url]
    hook&.destroy
    head :ok

  rescue StandardError => e
    ErrorMailer.webhook_notification_email(['Destroy HOOK', e.message], params).deliver
    head :forbidden
  end

  def catch
    if @webhook == 'wip'
      parse_wip
    elsif @webhook == 'topo'
      parse_topo unless request.delete?
      ErrorMailer.webhook_notification_email('DELETE Request from Topo', params).deliver if request.delete?
    elsif @webhook == 'stripe'
      parse_stripe
    end

    render plain: 'success', status: :ok

  rescue StandardError => e
    ErrorMailer.webhook_error_email(e, params).deliver
    render plain: 'failed', status: '400'
  end

  protected

  def verify_hook
    if params[:webhook_key] == ENV['WEBHOOK_SCHEDULE_KEY']
      @webhook = 'qc'

    elsif params[:webhook_key] == ENV['WEBHOOK_WIP_KEY']
      @webhook = 'wip'

    elsif params[:webhook_key] == 'topo'
      @webhook = 'topo'
      authenticate

    elsif params[:webhook_key] == ENV['WEBHOOK_STRIPE_KEY']
      @webhook = 'topo'

    else
      render nothing: true, status: :not_found
    end
  end

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_basic do |user, pass|
      user == 'topo' && pass == ENV['WEBHOOK_TOPO_PASS']
    end
  end

  def render_unauthorized
    headers['WWW-Authenticate'] = 'Basic realm="Happy Rabbit Portal Webhook"'
    render nothing: true, status: 401
  end

  def payload_params
    params.to_unsafe_hash.except('controller', 'action', 'webhook_key')
  end

  def parse_topo
    Delayed::Job.enqueue(TopoWebhookJob.new(params[:hook] && params[:hook].to_unsafe_h))
  end

  def parse_wip
    ActiveRecord::Base.transaction do
      updater = WipSchedule::Updater.new(params_file)

      results = updater.update_wip_orders

      if results[:notice] || results[:orders].any?
        HappyRabbitMailer.wip_update_notification_email(results).deliver
      end
    end

  rescue StandardError => e
    ErrorMailer.webhook_notification_email([e.message], params).deliver
  end

  def parse_stripe
    ErrorMailer.webhook_notification_email('Webhook received from Stripe', params).deliver
    Delayed::Job.enqueue(Portal::Stripe::WebhookJob.new(params[:object] && params[:object].to_unsafe_h))
    Delayed::Job.enqueue(StripeWebhookJob.new(params[:object] && params[:object].to_unsafe_h))
  end

  def params_file
    if params[:file].content_type == 'application/zip'
      extract_zip params[:file].tempfile.path
    else
      params[:file].tempfile
    end
  end

  def extract_zip(file)
    extracted_file = Tempfile.new(File.basename(file))

    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        if f.name[/\.xls$/]
          zip_file.extract(f, extracted_file) { true } # True to replace file if exists. Safe to do since it's a Tempfile
        end
      end
    end

    extracted_file
  end

  def hook_params
    params.require(:hook).permit(:event_name, :hook_url)
  end

  def current_resource_owner
    ::Refinery::Authentication::Devise::User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def ignore_test_requests
    if params[:hook_url] && params[:hook_url]['fake-subscription-url']
      render json: { id: 'fake-id' }, status: :created
    end
  rescue StandardError

  end

end
