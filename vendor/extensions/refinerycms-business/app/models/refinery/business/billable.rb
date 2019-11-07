module Refinery
  module Business
    class Billable < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_billables'

      class_attribute :registered_jobs, instance_writer: false

      TYPES = %w(commission cost product time)

      COMMISSION_UNITS = %w()
      COST_UNITS = %w()
      PRODUCT_UNITS = %w()
      TIME_UNITS = %w(day)
      
      STATUSES = %w(draft job_completed to_be_invoiced invoiced paid cancelled)

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ' - ' }

      belongs_to :company
      #belongs_to :project
      #belongs_to :section
      belongs_to :invoice
      belongs_to :assigned_to,        class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :article
      belongs_to :line_item_sales,    class_name: '::Refinery::Business::InvoiceItem'
      belongs_to :line_item_discount, class_name: '::Refinery::Business::InvoiceItem'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:title, :description, :article_code]

      delegate :invoice_number, :reference, to: :invoice, prefix: true, allow_nil: true
      delegate :label, to: :company, prefix: true, allow_nil: true

      validates :company_id,    presence: true
      validates :billable_type, inclusion: TYPES
      validates :title,         presence: true
      validates :qty_unit,      inclusion: COMMISSION_UNITS,  if: :billable_is_commission?
      validates :qty_unit,      inclusion: COST_UNITS,        if: :billable_is_commission?
      validates :qty_unit,      inclusion: PRODUCT_UNITS,     if: :billable_is_product?
      validates :qty_unit,      inclusion: TIME_UNITS,        if: :billable_is_time?
      validates :status,        inclusion: STATUSES

      before_validation do
        self.total_cost = qty * unit_price * (1.0 - discount) if qty.present? && unit_price.present?
        
        if invoice.present?
          if invoice.status == 'PAID'
            self.status = 'paid'
          elsif invoice.status == 'AUTHORISED'
            self.status = 'invoiced'
          else
            self.status = 'to_be_invoiced'
          end
        else
          self.status = 'draft'
        end
      end

      validate do
        if article.present?
          errors.add(:article_id, 'not allowed on this Billable') unless article.is_public or article.company == company
        end

        if line_item_sales.present?
          errors.add(:line_item_sales_id, 'cannot be from another invoice') unless line_item_sales.invoice_id == invoice_id
        end

        if line_item_discount.present?
          errors.add(:line_item_discount_id, 'cannot be from another invoice') unless line_item_discount.invoice_id == invoice_id
        end
      end

      before_save do
        if assigned_to.present?
          self.assigned_to_label = assigned_to.full_name
        end
        if invoice.present?
          self.archived_at = invoice.archived_at
        end
        if article.present?
          self.article_code = article.code
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

      def units_for_type
        case billable_type
        when 'commission' then COMMISSION_UNITS
        when 'product' then PRODUCT_UNITS
        when 'time' then TIME_UNITS
        else []
        end
      end

      def manufacturer_label
        ::Refinery::QualityAssurance::Job
        all_jobs.select { |j|
          j.respond_to? :inspection
        }.map { |j|
          j.inspection&.manufacturer_label
        }.uniq.compact.join(', ')
      end

      def is_base_unit?
        qty_unit == units_for_type.first
      end

      def self.to_source
        where(nil).pluck(:id, :title, :assigned_to_label, :billable_date).map(&PROC_LABEL).to_json.html_safe
      end

      def label
        PROC_LABEL.call(id, title, assigned_to_label, billable_date)
      end

      def self.find_by_label(label)
        find_by id: label.split(' - ').first
      end

      def invoice_label
        @invoice_label ||= invoice.try(:label)
      end

      def invoice_label=(label)
        self.invoice = Invoice.find_by_label label
        @invoice_label = label
      end

      # def assigned_to_label
      #   @assigned_to_label ||= assigned_to.try(:label)
      # end

      def assigned_to_label=(label)
        self.assigned_to = ::Refinery::Authentication::Devise::User.find_by_label label
        super
      end

      def article_code=(label)
        self.article = Article.is_public.non_voucher.find_by_label label
        super
      end

      def all_jobs
        @all_jobs ||= all_job_association_names.inject([]) do |acc, assoc_name|
          acc.concat send(assoc_name)
        end
      end

      def total_no_of_jobs
        all_jobs.count
      end

      def allocated_by(scope)
        Rational(1) * all_jobs.select { |j|
          if scope.is_a? Refinery::Business::Section
            j.section == scope
          end
        }.count / total_no_of_jobs
      end

      def self.register_job(klass, assoc_name, options = {})
        self.registered_jobs ||= {}
        registered_jobs[assoc_name] = options.merge(class_name: klass.name)

        has_many assoc_name, class_name: klass.name, dependent: :nullify

      end

      def all_job_association_names
        (registered_jobs || {}).keys
      end

      def display_status
        if status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.statuses.#{status}"
        end
      end

      def self.status_options
        STATUSES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses.#{k}"),k] }
      end

      def self.from_params(params)
        active = ActiveRecord::Type::Boolean.new.type_cast_from_user(params.fetch(:active, true))
        archived = ActiveRecord::Type::Boolean.new.type_cast_from_user(params.fetch(:archived, true))

        if active && archived
          where(nil)
        elsif active
          where(archived_at: nil)
        elsif archived
          where.not(archived_at: nil)
        else
          where('1=0')
        end
      end

    end
  end
end
