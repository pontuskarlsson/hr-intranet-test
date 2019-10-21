Refinery::Shipping::Shipment.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  acts_as_notifiable :'refinery/authentication/devise/users',
                     targets: ->(shipment, key) {
                       internal_users = Refinery::Authentication::Devise::User.where(email: ['daniel.viklund@happyrabbit.com', 'pontus.karlsson@happyrabbit.com', 'yvonne.wong@happyrabbit.com'])
                       # ff_users = Refinery::Authentication::Devise::User.for_role(Refinery::Shipping::ROLE_EXTERNAL_FF).for_companies(shipment.forwarder_company)
                       # con_users = Refinery::Authentication::Devise::User.for_role(Refinery::Shipping::ROLE_EXTERNAL).for_companies(shipment.consignee_company)
                       #
                       # if key['shipment.status_request']
                       #   internal_users + ff_users
                       # elsif key['shipment.status_summary']
                       #   internal_users + ff_users + con_users
                       # end
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
    !%w(shipment.status_request shipment.status_summary).include? key
  end

  def printable_name
    code
  end

end
