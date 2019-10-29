module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ', ' }

      INVOICE_TYPES = %w(ACCREC ACCPAY)
      STATUSES = %w(DRAFT SUBMITTED DELETED AUTHORISED PAID VOIDED)

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
      acts_as_indexed :fields => [:invoice_number]

      validates :account_id,    presence: true
      validates :invoice_id,    presence: true, uniqueness: true
      validates :contact_id,    presence: true
      validates :invoice_type,  inclusion: INVOICE_TYPES
      validates :status,        inclusion: STATUSES

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

      scope :invoices, -> { where(invoice_type: 'ACCREC') }
      scope :bills, -> { where(invoice_type: 'ACCPAY') }
      scope :active, -> { where.not(status: %w(DELETED VOIDED)) }
      scope :overdue, -> { active.where('amount_due > 0').where('due_date < ?', Date.today) }

      def display_total
        "#{total_amount} #{currency_code}"
      end

      def total_cost_from_billables
        @total_cost_from_billables ||= billables.map(&:total_cost).reduce(0, :+)
      end

      def billable_cost_diff
        total_cost_from_billables - total_amount
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

    end
  end
end
