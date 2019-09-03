class TopoWebhookJob < Struct.new(:payload)

  def perform
    ActiveRecord::Base.transaction do
      syncer = Portal::Topo::Syncer.new
      syncer.run_webhook! payload

      if syncer.error
        ErrorMailer.error_email(syncer.error).deliver

      elsif syncer.inspection
        if syncer.inspection.status == 'Inspected'
          syncer.inspection.notify :'refinery/authentication/devise/users', key: 'inspection.verify'
          syncer.inspection.save!
        end
      end

    end
  rescue StandardError => e
    ErrorMailer.error_email(e).deliver
  end

  def log(msg)
    logger.info "[TopoWebhookJob] #{Time.now.strftime('%H:%M:%S')} >> #{msg}"
    puts "[TopoWebhookJob] #{Time.now.strftime('%H:%M:%S')} >> #{msg}" if Rails.env.development?
  end

  def logger
    @logger ||=
        if Rails.env.development?
          Rails.logger = Logger.new(STDOUT)
        else
          Rails.logger
        end
  end

  def users_for_role(title)
    role = Refinery::Authentication::Devise::Role.find_by_title(title)
    if role.present?
      role.users
    else
      []
    end
  end

end
