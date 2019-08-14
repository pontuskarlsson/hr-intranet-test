Refinery::Shipping::Shipment.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  acts_as_notifiable :'refinery/authentication/devise/users',
                     targets: ->(shipment, key) {
                       Refinery::Authentication::Devise::User.for_role(Refinery::Shipping::ROLE_INTERNAL) +
                           Refinery::Authentication::Devise::User.for_role(Refinery::Shipping::ROLE_EXTERNAL_FF).for_companies(shipment.forwarder_company)
                     },
                     tracked: false, # no automatic callbacks
                     # group: :article,
                     # notifier: :user,
                     email_allowed: :is_email_allowed?

  def notifiable_path(target, key)
    refinery.shipping_shipment_path(self)
  end

  def is_email_allowed?(target, key)
    # Do not send out emails for each status requests. After notifications
    # have been created, batch emails will be sent out instead.
    key != 'shipment.status_request'
  end

  def printable_name
    code
  end

end
