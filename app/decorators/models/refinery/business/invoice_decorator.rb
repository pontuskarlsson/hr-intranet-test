Refinery::Business::Invoice.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  acts_as_notifiable :'refinery/authentication/devise/users',
                     targets: ->(invoice, key) {
                       Refinery::Authentication::Devise::User.for_role(Refinery::Business::ROLE_INTERNAL_FINANCE)
                     },
                     tracked: false, # no automatic callbacks
                     # group: :article,
                     # notifier: :user,
                     email_allowed: :is_email_allowed?

  acts_as_notifiable :'refinery/business/billing_accounts',
                     targets: ->(invoice, key) {
                       Refinery::Business::BillingAccount.where(company_id: invoice.company_id)
                     },
                     tracked: false, # no automatic callbacks
                     email_allowed: :is_ba_email_allowed?

  def notifiable_path(target, key)
    refinery.business_invoice_path(self)
  end

  def is_email_allowed?(target, key)
    # Do not send out emails for notifications that will be batch notified afterwards.
    !%w(invoice.prepared invoice.payout).include? key
  end

  def is_ba_email_allowed?(target, key)
    # Do not send out emails for notifications that will be batch notified afterwards.
    !%w().include? key
  end

  def printable_name
    invoice_number
  end

  def default_notification_key
    "#{to_resource_name}.default"
  end

  def overriding_notification_email_subject(target, key)
    case key
    when 'invoice.issued' then "Invoice #{invoice_number} has been issued"
    when 'batch.invoice.payout' then "Stripe Payout"
    else "Invoice #{invoice_number}"
    end
  end

end
