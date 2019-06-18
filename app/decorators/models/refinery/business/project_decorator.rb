Refinery::Business::Project.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  acts_as_notifiable :'refinery/authentication/devise/users',
                     targets: ->(project, key) {
                       Refinery::Authentication::Devise::User.for_role(Refinery::Business::ROLE_INTERNAL_FINANCE)
                     },
                     tracked: false, # no automatic callbacks
                     # group: :article,
                     # notifier: :user,
                     email_allowed: :is_email_allowed?

  def notifiable_path(target, key)
    refinery.business_project_path(self)
  end

  def is_email_allowed?(target, key)
    true
  end

  def printable_name
    "Project #{code}"
  end

  def default_notification_key
    "#{to_resource_name}.default"
  end

end
