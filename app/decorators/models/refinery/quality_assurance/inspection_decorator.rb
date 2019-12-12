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
                         users.for_role(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER) +
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
    @tbv << 'Inspector should be full name, not only first or last name' if inspected_by_name.present? && inspected_by_name[' '].nil?
    @tbv << 'PO is missing' if po_number.blank?
    @tbv << 'Result is missing' if result.blank?
    @tbv << 'Inspection type is missing' if inspection_type.blank?
    # @tbv << 'PO Number contains the slash (/) character. If multiple POs are inspected, then the comma (,) character should be used to separate them' if (po_number || '')['/']
    # @tbv << 'Colour contains the slash (/) character. This could be correct if a variant is a combination of colours, but if there are multiple variants inspected, the comma (,) character should be used' if (product_colour_variants || '')['/']
    # inspection_defects.each do |inspection_defect|
    #   @tbv << "#{inspection_defect.defect_label} has 0 number of defects, this must be incorrect" if inspection_defect.total_no_of_defects.zero?
    # end

    @tbv
  end

  def to_builder(json)
    json.(inspection, :id, :job_id, :code)
    json.(inspection, :company_id, :company_label, :company_code)
    json.(inspection, :supplier_id, :supplier_label, :supplier_code)
    json.(inspection, :manufacturer_id, :manufacturer_label, :manufacturer_code)
    json.(inspection, :inspected_by_id, :inspected_by_name)
    json.(inspection, :project_code, :company_project_reference)

    json.(inspection, :result, :inspection_date, :status)

    json.(inspection, :po_number, :po_type, :po_qty, :available_qty)
    json.(inspection, :product_code, :product_description, :product_colour_variants)

    json.(inspection, :inspection_type, :inspection_standard, :inspection_sample_size)
    json.(inspection, :acc_critical, :acc_major, :acc_minor, :total_critical, :total_major, :total_minor)

    json.defects inspection.inspection_defects do |inspection_defect|
      json.(inspection_defect, :id, :defect_id, :inspection_id)
      json.(inspection_defect, :critical, :major, :minor, :comments, :defect_label, :can_fix)
    end
  end

end
