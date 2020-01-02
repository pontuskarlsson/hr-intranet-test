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

                       elsif inspection.company_code == '00441'
                         users.for_role(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER) +
                         users.for_role(Refinery::QualityAssurance::ROLE_EXTERNAL).for_companies(inspection.company).for_meta(product_category: inspection.product_category)

                       else
                         users.for_role(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER) +
                         users.for_role(Refinery::QualityAssurance::ROLE_EXTERNAL).for_companies(inspection.company)
                       end
                     },
                     tracked: false, # no automatic callbacks
                     # group: :article,
                     # notifier: :user,
                     email_allowed: :is_email_allowed?

  after_save do
    if status_changed? && status == 'Notified'
      delay.trigger_zap(RestHook::INSPECTION_NEW)
    end
  end

  def trigger_zap(event)
    encoded_record = Jbuilder.encode { |json| to_builder json }
    user_ids = Refinery::Authentication::Devise::User.for_role(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER).pluck(:id)
    RestHook.where(user_id: user_ids).trigger(event, encoded_record)
  end

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
    @tbv << 'Incorrect Brand' if brand_label == 'Stay In Place' && company&.code != '00375'
    @tbv << 'Incorrect Brand' if brand_label == 'Wood Wood' && company&.code != '00008'
    # @tbv << 'PO Number contains the slash (/) character. If multiple POs are inspected, then the comma (,) character should be used to separate them' if (po_number || '')['/']
    # @tbv << 'Colour contains the slash (/) character. This could be correct if a variant is a combination of colours, but if there are multiple variants inspected, the comma (,) character should be used' if (product_colour_variants || '')['/']
    # inspection_defects.each do |inspection_defect|
    #   @tbv << "#{inspection_defect.defect_label} has 0 number of defects, this must be incorrect" if inspection_defect.total_no_of_defects.zero?
    # end

    @tbv
  end

  def to_builder(json)
    json.(self, :id, :job_id, :code)
    json.(self, :company_id, :company_label, :company_code)
    json.(self, :supplier_id, :supplier_label, :supplier_code)
    json.(self, :manufacturer_id, :manufacturer_label, :manufacturer_code)
    json.(self, :inspected_by_id, :inspected_by_name)
    json.(self, :project_code, :company_project_reference)

    json.(self, :result, :inspection_date, :status, :summary_comment)

    json.(self, :po_number, :po_type, :po_qty, :available_qty)
    json.(self, :product_code, :product_description, :product_colour_variants)

    json.(self, :inspection_type, :inspection_standard, :inspection_sample_size)
    json.(self, :acc_critical, :acc_major, :acc_minor, :total_critical, :total_major, :total_minor)

    json.defects inspection_defects do |inspection_defect|
      inspection_defect.to_builder json
    end

    json.photos inspection_photos do |inspection_photo|
      inspection_photo.to_builder json
    end

    json.document_url expiring_url
    json.location_url refinery.quality_assurance_inspection_url(self, host: ENV['MAIL_DEFAULT_HOST'], protocol: 'https')
    json.preview_url inspection_photos.detect { |ip| ip.preview_photo? }&.expiring_url

    json.(self, :created_at, :updated_at)
  end

end
