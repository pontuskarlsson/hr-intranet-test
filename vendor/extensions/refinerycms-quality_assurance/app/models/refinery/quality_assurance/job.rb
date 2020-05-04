module Refinery
  module QualityAssurance
    class Job < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_jobs'

      STATUSES = %w(Draft Confirmed Scheduled Completed Invoiced)
      JOB_TYPES = %w(Inspection)
      BILLABLE_TYPES = %w(ManDay)
      COMPLEXITY_LEVELS = %w(low medium high)

      store :content, accessors: [:po_numbers, :product_codes, :product_category, :complexity]

      belongs_to :assigned_to,      class_name: '::Refinery::Authentication::Devise::User', optional: true
      belongs_to :company,          class_name: '::Refinery::Business::Company', optional: true
      belongs_to :project,          class_name: '::Refinery::Business::Project', optional: true
      belongs_to :section,          class_name: '::Refinery::Business::Section', optional: true
      belongs_to :billable,         class_name: '::Refinery::Business::Billable', optional: true
      belongs_to :visit, optional: true
      has_one :inspection,          dependent: :nullify

      # Registers self as a possible Billable Job
      include ::Refinery::Business::Job
      configure_job self, :quality_assurance_jobs, billable_type: 'time'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:code, :title, :description, :company_code, :company_label, :assigned_to_label]
      configure_assign_by_label :billable, class_name: '::Refinery::Business::Billable'
      configure_assign_by_label :project, class_name: '::Refinery::Business::Project'

      configure_enumerables :complexity, COMPLEXITY_LEVELS

      has_comments

      delegate :label, to: :project, prefix: true, allow_nil: true

      #validates :company_id,        presence: true # Remove validation since some inspections from external might not be able to match company name initially
      validates :status,            inclusion: STATUSES
      validates :job_type,          inclusion: JOB_TYPES
      validates :billable_type,     inclusion: BILLABLE_TYPES

      validate do
        if project.present?
          errors.add(:project_id, 'cannot use project from another company') unless project.company_id == company_id
        end
        if section.present?
          errors.add(:section_id, 'cannot use section from another project') unless section.project_id == project_id
        end
        if billable.present?
          errors.add(:billable_id, 'cannot use billable from another company') unless billable.company_id == company_id
        end
      end

      before_validation(on: :create) do
        self.status ||= 'Draft'
        assign_code!
      end

      before_validation do
        # Clear Section association if project changed
        self.section = nil if project_id_changed?

        # Assign an existing or create a new section based on the project association (if present)
        if project.present?
          self.section ||= project.sections.find_or_create_by!(section_type: 'QA') { |section|
            section.description = "Inspections #{project.description}"
          }
        end

        self.complexity ||= 'medium'
      end

      before_save do
        if company.present?
          self.company_code = company.code
          self.company_label = company.name

          if billable.nil?
            self.billable =
                if (job = company.jobs.billable_with(self).first).present?
                  job.billable
                else
                  company.billables.create!(
                      billable_type: 'time',
                      billable_date: inspection_date,
                      assigned_to_id: assigned_to_id,
                      assigned_to_label: assigned_to_label,
                      title: 'QA/QC Job(s)',
                      qty: 1,
                      qty_unit: 'day',
                      article_code: ''
                  )
                end
          end
        end

        if project.present?
          self.company_project_reference = project.company_reference
          self.project_code = project.code
        end

        if assigned_to.present?
          self.assigned_to_label = assigned_to.full_name
        end
      end

      after_save do
        if inspection.present? && product_category.present? && product_category != inspection.product_category
          inspection.product_category = product_category
          inspection.save || throw(:abort)
        end
      end

      scope :billable_with, -> (job) {
        where.not(billable_id: nil).
            where.not(id: job.id).
            where(assigned_to_label: job.assigned_to_label, inspection_date: job.inspection_date, company_id: job.company_id)
      }
      scope :for_companies, -> (companies) { where(company_id: Array(companies).map(&:id)) }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include?(ROLE_INTERNAL) or titles.include?(ROLE_INTERNAL_MANAGER)
          where(nil)

        elsif titles.include? ROLE_EXTERNAL
          for_companies(user.companies)

        else
          none
        end
      end

      def self.for_selected_company(selected_company)
        if selected_company.nil?
          where(nil)
        else
          where(company_id: selected_company.id)
        end
      end

      def assign_code!
        if code.blank?
          self.code = ::Refinery::Business::NumberSerie.next_counter!(::Refinery::QualityAssurance::Inspection, :code, prefix: 'QA-', pad_length: 6)
        end
      end

      def purchase_orders
        Array(po_numbers).map { |po| PurchaseOrder.new(po) }
      end

      def purchase_orders_attributes=(attr)
        self.po_numbers = Hash(attr).values.reduce([]) do |acc, val|
          if val.respond_to?(:stringify_keys) && val.stringify_keys['code'].present?
            acc << val.stringify_keys['code']
          else
            acc
          end
        end
      end

      def submitter_email
        created_by_email
      end

      def submitter_full_name
        created_by_full_name
      end

      def requester_email
        requested_by_email
      end

      def requester_full_name
        requested_by_full_name
      end

      def default_subject
        if job_type == 'Inspection'
          [code, inspection&.po_number, inspection&.product_code].reject(&:blank?).join ' - '
        else
          code
        end
      end

      class PurchaseOrder < Struct.new(:code)

        def persisted?
          false
        end

      end

      def products
        Array(product_codes).map { |po| Product.new(po) }
      end

      def products_attributes=(attr)
        self.product_codes = Hash(attr).values.reduce([]) do |acc, val|
          if val.respond_to?(:stringify_keys) && val.stringify_keys['code'].present?
            acc << val.stringify_keys['code']
          else
            acc
          end
        end
      end

      class Product < Struct.new(:code)

        def persisted?
          false
        end

      end

    end
  end
end
