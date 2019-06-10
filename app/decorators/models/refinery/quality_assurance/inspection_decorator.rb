Refinery::QualityAssurance::Inspection.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  acts_as_notifiable :'refinery/authentication/devise/users',
                     targets: ->(inspection, key) {
                       Refinery::Authentication::Devise::User.for_role(Refinery::QualityAssurance::ROLE_INTERNAL) +
                       Refinery::Authentication::Devise::User.for_role(Refinery::QualityAssurance::ROLE_EXTERNAL).for_companies(inspection.company)
                     },
                     tracked: false, # no automatic callbacks
                     # group: :article,
                     # notifier: :user,
                     email_allowed: :is_email_allowed?

  def notifiable_path(target, key)
    refinery.quality_assurance_inspection_path(self)
  end

  def is_email_allowed?(target, key)
    result.present? && inspection_date.present? && inspection_date > Date.today - 7.days
  end

  def printable_name
    "the inspection for #{label}"
  end

  def default_notification_key
    "#{to_resource_name}.#{result.try(:downcase) || 'default'}"
  end

end
