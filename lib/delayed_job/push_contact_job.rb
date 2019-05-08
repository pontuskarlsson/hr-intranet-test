class PushContactJob < Struct.new(:contact_id, :changes)

  def perform
    return

    contact = Refinery::Marketing::Contact.find(contact_id)
    synchroniser = Refinery::Marketing::Insightly::Synchroniser.new
    synchroniser.push contact, changes

    if synchroniser.error
      ErrorMailer.error_email(synchroniser.error).deliver
    end
  rescue StandardError => e
    ErrorMailer.error_email(e).deliver
  end

  def log(msg)
    logger.info "[PushContactJob] #{Time.now.strftime('%H:%M:%S')} >> #{msg}"
    puts "[PushContactJob] #{Time.now.strftime('%H:%M:%S')} >> #{msg}" if Rails.env.development?
  end

  def logger
    @logger ||=
        if Rails.env.development?
          Rails.logger = Logger.new(STDOUT)
        else
          Rails.logger
        end
  end

end
