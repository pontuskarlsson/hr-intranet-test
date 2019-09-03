Refinery::QualityAssurance::Inspection.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  attr_reader :only_notify_targets

  acts_as_notifiable :'refinery/authentication/devise/users',
                     targets: ->(inspection, key) {
                       users = Refinery::Authentication::Devise::User.where(nil)

                       if inspection.explicit_target_for_notification?
                         inspection.only_notify_targets

                       elsif key == 'inspection.verify'
                         users.for_role(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER)

                       else
                         users.for_role(Refinery::QualityAssurance::ROLE_INTERNAL) +
                         users.for_role(Refinery::QualityAssurance::ROLE_EXTERNAL).for_companies(inspection.company)
                       end
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

  def overriding_notification_email_subject(target, key)
    # Take two first present attributes from below
    reference = [product_code, product_description, po_number].reject(&:blank?)[0..1].join(', ')

    "#{code}: #{inspection_type} Inspection Completed for #{reference}"
  end

  def notify_only(targets, *options)
    @only_notify_targets = targets
    notify :'refinery/authentication/devise/users', *options
  end

  def explicit_target_for_notification?
    only_notify_targets.present?
  end

  def to_be_verified
    return @tbv unless @tbv.nil?

    @tbv = []

    @tbv << 'Customer could not be found' if company.nil?
    @tbv << 'Supplier could not be found' if supplier.nil?
    @tbv << 'Manufacturer could not be found' if manufacturer.nil?
    @tbv << 'PO Number contains the slash (/) character. If multiple POs are inspected, then the comma (,) character should be used to separate them' if (po_number || '')['/']
    @tbv << 'Colour contains the slash (/) character. This could be correct if a variant is a combination of colours, but if there are multiple variants inspected, the comma (,) character should be used' if (product_colour_variants || '')['/']
    inspection_defects.each do |inspection_defect|
      @tbv << "#{inspection_defect.defect_label} has 0 number of defects, this must be incorrect" if inspection_defect.total_no_of_defects.zero?
    end

    @tbv
  end

end
