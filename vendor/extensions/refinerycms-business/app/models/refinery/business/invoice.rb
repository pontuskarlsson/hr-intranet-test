module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ', ' }

      INVOICE_TYPES = %w(ACCREC ACCPAY)
      STATUSES = %w(DRAFT SUBMITTED DELETED AUTHORISED PAID VOIDED)
      MANAGED_STATUSES = %w(draft submitted changed)
      CURRENCY_CODES = %w(USD HKD EUR SEK CNY THB)

      belongs_to :account
      belongs_to :company
      belongs_to :from_company, class_name: 'Company'
      belongs_to :to_company,   class_name: 'Company'
      belongs_to :project
      has_many :billables,      dependent: :nullify
      has_many :invoice_items,  dependent: :destroy

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:invoice_number, :invoice_date, :reference]

      validates :account_id,      presence: true
      validates :invoice_id,      uniqueness: true, allow_blank: true
      validates :currency_code,   presence: true
      validates :currency_code,   inclusion: CURRENCY_CODES, if: -> { is_managed }
      #validates :contact_id,      presence: true
      validates :invoice_type,    inclusion: INVOICE_TYPES
      validates :status,          inclusion: STATUSES
      validates :managed_status,  inclusion: MANAGED_STATUSES, allow_nil: true
      validates :managed_status,  presence: true, if: -> { is_managed }

      validate do
        if invoice_for_month.present?
          unless invoice_for_month == invoice_for_month.beginning_of_month
            errors.add(:invoice_for_month, 'must be first of the month')
          end
          if company.present? && company.invoices.where(invoice_for_month: invoice_for_month).where.not(id: id).exists?
            errors.add(:invoice_for_month, 'an Invoice of the month has already been added for this month')
          end
        end
      end

      before_validation do
        if currency_code == 'USD'
          self.currency_rate ||= 0.128205
        end

        self.managed_status ||= 'draft' if is_managed
      end

      before_save do
        if %w(DELETED VOIDED).include?(status)
          self.archived_at ||= DateTime.now
        end
      end

      after_save do
        if archived_at_changed?
          billables.update_all(archived_at: archived_at)
        end
      end

      scope :invoices,  -> { where(invoice_type: 'ACCREC') }
      scope :bills,     -> { where(invoice_type: 'ACCPAY') }
      scope :active,    -> { where.not(status: %w(DELETED VOIDED)) }
      scope :overdue,   -> { active.where('amount_due > 0').where('due_date < ?', Date.today) }

      def display_total
        "#{total_amount} #{currency_code}"
      end

      def total_cost_from_billables
        @total_cost_from_billables ||= billables.map(&:total_cost).reduce(0, :+)
      end

      def billable_cost_diff
        total_cost_from_billables - total_amount
      end

      def approved?
        %w(AUTHORISED PAID).include? status
      end

      def label
        PROC_LABEL.call(invoice_number, invoice_date, reference)
      end

      def company_label
        @company_label ||= company.try(:label)
      end

      def company_label=(label)
        self.company = Company.find_by_label label
        @company_label = label
      end

      def project_label
        @project_label ||= project.try(:label)
      end

      def project_label=(label)
        self.project = Project.find_by_label label
        @project_label = label
      end

      def self.find_by_label(label)
        find_by invoice_number: label.split(', ').first
      end

      def self.to_source
        order(invoice_number: :desc).pluck(:invoice_number, :invoice_date, :reference).map(&PROC_LABEL).to_json.html_safe
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

      MANAGED_STATUSES.each do |ms|
        define_method :"managed_status_is_#{ms}?" do
          managed_status == ms
        end
      end

      def display_managed_status
        if managed_status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.managed_statuses.#{managed_status}"
        end
      end

      def self.managed_status_options
        MANAGED_STATUSES.reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.managed_statuses.#{k}"),k] }
      end

    end
  end
end
