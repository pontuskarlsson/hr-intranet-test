module Refinery
  module Business
    class Billable < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_billables'

      class_attribute :registered_jobs, instance_writer: false

      TYPES = %w(commission product time)

      COMMISSION_UNITS = %w()
      PRODUCT_UNITS = %w()
      TIME_UNITS = %w(day)

      ARTICLE_CODES = %w(CONSULTANT-QCQA-CN-DAY CONSULTANT-QCQA-VN-DAY CONSULTANT-QCQA-TH-DAY CONSULTANT-QCQA-ID-DAY)

      belongs_to :company
      #belongs_to :project
      #belongs_to :section
      belongs_to :invoice
      belongs_to :assigned_to,      class_name: '::Refinery::Authentication::Devise::User'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:title, :description]

      delegate :invoice_number, to: :invoice, prefix: true, allow_nil: true
      delegate :label, to: :company, prefix: true, allow_nil: true

      validates :company_id,    presence: true
      validates :billable_type, inclusion: TYPES
      validates :article_code,  inclusion: ARTICLE_CODES,     allow_blank: true
      validates :title,         presence: true
      validates :qty_unit,      inclusion: COMMISSION_UNITS,  if: :billable_is_commission?
      validates :qty_unit,      inclusion: PRODUCT_UNITS,     if: :billable_is_product?
      validates :qty_unit,      inclusion: TIME_UNITS,        if: :billable_is_time?

      before_validation do
        self.total_cost = qty * unit_price * (1.0 - discount)
      end

      before_save do
        if assigned_to.present?
          self.assigned_to_label = assigned_to.full_name
        end
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

      def display_billable_type
        billable_type.present? ? billable_type.capitalize : 'N/A'
      end

      def display_qty
        "#{qty} #{qty_unit}"
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

      def all_jobs
        all_job_association_names.inject([]) do |acc, assoc_name|
          acc.concat send(assoc_name)
        end
      end

      def self.register_job(klass, assoc_name, options = {})
        self.registered_jobs ||= {}
        registered_jobs[assoc_name] = options.merge(class_name: klass.name)

        has_many assoc_name, class_name: klass.name, dependent: :nullify

      end

      def all_job_association_names
        (registered_jobs || {}).keys
      end

    end
  end
end
