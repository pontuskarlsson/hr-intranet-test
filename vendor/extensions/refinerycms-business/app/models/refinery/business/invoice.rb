module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

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

      configure_assign_by_label :company, class_name: '::Refinery::Business::Company'
      configure_assign_by_label :project, class_name: '::Refinery::Business::Project'
      configure_enumerables :invoice_type,    INVOICE_TYPES
      configure_enumerables :managed_status,  MANAGED_STATUSES
      configure_enumerables :status,          STATUSES
      configure_label :invoice_number, :invoice_date, :reference, sort: :desc, separator: ', '
      display_date_for :invoice_date, :due_date

      store :plan_details, accessors: [ :plan_title, :plan_description, :plan_monthly_minimums, :plan_opening_balance, :plan_redeemed, :plan_issued, :plan_closing_balance ], coder: JSON, prefix: :plan

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

      def display_billing_period(format = '%b %e, %Y')
        if invoice_for_month.present?
          [
              invoice_for_month.at_beginning_of_month.strftime(format),
              invoice_for_month.at_end_of_month.strftime(format),
          ].join(' - ')
        else
          '&nbsp;'.html_safe
        end
      end

      def buyer_reference
        'N/A'
      end

      def monthly_billables
        @monthly_billables ||= Array(plan_monthly_minimums).map { |mm| mm.merge('article' => Article.find_by_label(mm['article_label'])) }
      end

      def number_of_man_days
        billables.sum(:qty)
      end

      def number_of_inspections
        billables.reduce(0) { |acc, billable| acc + billable.total_no_of_jobs }
      end

      def number_of_pieces_inspected
        billables.reduce(0) do |acc, billable|
          acc + billable.number_of_pieces_inspected
        end
      end

      def number_of_locations
        billables.map(&:location).uniq.count
      end

      def total_pass_rate
        res = billables.map(&:quality_assurance_jobs).flatten.map(&:inspection).compact.each_with_object([0.0, 0.0]) do |inspection, acc|
          acc[inspection.result_is_pass? ? 0 : 1] = inspection.po_qty
        end

        if res[0] + res[1] == 0
          1.0
        else
          res[0].to_f / (res[0] + res[1])
        end
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
