module Refinery
  module Business
    class Billable < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_billables'

      class_attribute :registered_jobs, instance_writer: false

      TYPES = %w(commission product time)

      COMMISSION_UNITS = %w()
      PRODUCT_UNITS = %w()
      TIME_UNITS = %w(day)

      belongs_to :company
      #belongs_to :project
      #belongs_to :section
      belongs_to :invoice

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:title, :description]

      delegate :invoice_number, to: :invoice, prefix: true, allow_nil: true
      delegate :code, :description, to: :project, prefix: true, allow_nil: true
      delegate :label, to: :company, prefix: true, allow_nil: true

      validates :company_id,    presence: true
      validates :billable_type, inclusion: TYPES
      validates :article_code,  presence: true
      validates :title,         presence: true
      validates :qty_unit,      inclusion: COMMISSION_UNITS,  if: :billable_is_commission?
      validates :qty_unit,      inclusion: PRODUCT_UNITS,     if: :billable_is_product?
      validates :qty_unit,      inclusion: TIME_UNITS,        if: :billable_is_time?

      # validate do
      #   if project.present?
      #     errors.add(:project_id, :invalid) unless project.company_id == company_id
      #   end
      # end

      before_validation do
        self.total_cost = qty * unit_price * (1.0 - discount)
      end

      def billable_is_commission?
        billable_type == 'commission'
      end

      def billable_is_product?
        billable_type == 'product'
      end

      def billable_is_time?
        billable_type == 'time'
      end

      def display_project
        if project.present?
          project.label
        else
          'N/A'
        end
      end

      def display_invoice
        if invoice.present?
          invoice.label
        else
          'N/A'
        end
      end

      def label
        title
      end

      def invoice_label
        @invoice_label ||= invoice.try(:label)
      end

      def invoice_label=(label)
        self.invoice = Invoice.find_by_label label
        @invoice_label = label
      end

      def project_label
        @project_label ||= project.try(:label)
      end

      def project_label=(label)
        self.project = ::Refinery::Business::Project.find_by_label label
        @project_label = label
      end

      def all_jobs
        registered_jobs.keys.inject([]) do |acc, assoc_name|
          acc.concat send(assoc_name)
        end
      end

      def self.register_job(klass, assoc_name, options = {})
        self.registered_jobs ||= {}
        registered_jobs[assoc_name] = options.merge(class_name: klass.name)

        has_many assoc_name, class_name: klass.name, dependent: :nullify

      end

      def self.all_job_association_names
        registered_jobs.keys
      end

    end
  end
end
