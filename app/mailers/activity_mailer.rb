class ActivityMailer < ActivityNotification::Mailer

  # Initialize instance variables from notification.
  #
  # @param [Notification] notification Notification instance
  def initialize_from_notification(notification)
    super

    case notification.key
    when 'invoice.issued' then attach_invoice_statement(notification.notifiable)
    end
  end

  # Attach a pdf statement to the email notification
  #
  # @param [Invoice] invoice Invoice instance
  def attach_invoice_statement(invoice)
    if (resource = invoice&.statement&.resource).present?
      attachments[resource.file.name] ||= resource.file.data
    end
  end

  # Prepare email header from notification key and options.
  #
  # @param [String] key Key of the notification
  # @param [Hash] options Options for email notification
  def headers_for(key, options)
    super.tap do |headers|
      if key == 'invoice.issued'
        headers[:from] = 'Happy Rabbit Finance <finance@happyrabbit.com>'
        headers[:bcc] = 'finance@happyrabbit.com'
      end
    end
  end

end
