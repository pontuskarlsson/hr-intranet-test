class HooksController < ApplicationController
  CALENDAR_FUNCTION = 'QCSchedule'

  before_filter :verify_hook
  skip_before_filter :verify_authenticity_token, :authenticate_refinery_user!

  def catch
    if @webhook == 'qc'
      parse_qc
    elsif @webhook == 'wip'
      parse_wip
    end

    render text: 'success', status: :ok

  rescue RangeError => e
    ErrorMailer.schedule_error_email(e, params).deliver
    render text: 'failed', status: '400'

  rescue StandardError => e
    ErrorMailer.schedule_error_email(e, params).deliver
    render text: 'failed', status: '400'
  end

  protected

  def verify_hook
    if params[:webhook_key] == ENV['WEBHOOK_SCHEDULE_KEY']
      @webhook = 'qc'

    elsif params[:webhook_key] == ENV['WEBHOOK_WIP_KEY']
      @webhook = 'wip'

    else
      render nothing: true, status: :not_found
    end
  end

  def payload_params
    params.to_unsafe_hash.except('controller', 'action', 'webhook_key')
  end

  def parse_qc
    ActiveRecord::Base.transaction do
      wip_schedule = WipSchedule.new

      msgs = WipSchedule.update_wip_orders params[:file].tempfile.path

      if msgs.any?
        ErrorMailer.wip_notification_email(msgs, params).deliver
      end
    end
  end

  def parse_wip
    ActiveRecord::Base.transaction do
      @xlsx = Roo::Excelx.new(params[:file].tempfile.path, file_warning: :ignore)
      sheet = @xlsx.sheet('SCHEDULE')

    end

    ErrorMailer.schedule_notification_email(['At least it triggered'], params).deliver
  end

end
