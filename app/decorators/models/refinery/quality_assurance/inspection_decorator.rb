Refinery::QualityAssurance::Inspection.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  acts_as_notifiable :users,
                     targets: ->(inspection, key) {
                       Refinery::Authentication::Devise::User.for_role(Refinery::QualityAssurance::ROLE_INTERNAL)
                     },
                     tracked: false # no automatic callbacks
                     # group: :article,
                     # notifier: :user,
                     # email_allowed: :custom_notification_email_to_users_allowed?,

  def notifiable_path(target, key)
    refinery.quality_assurance_inspection_path(self)
  end

  def printable_name
    "the inspection for #{label}"
  end

end
