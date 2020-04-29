module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

      INVOICE_TYPES = %w(ACCREC ACCPAY)
      STATUSES = %w(DRAFT SUBMITTED DELETED AUTHORISED PAID VOIDED)
      MANAGED_STATUSES = %w(draft submitted_for_approval approved issued authorised sent paid voided)
      CURRENCY_CODES = %w(USD HKD EUR SEK CNY THB)

      CURRENCY_RATES = {
          'USD' => 0.128205
      }.freeze

      DEFAULT_CURRENCY = 'USD'

      belongs_to :account, optional: true
      belongs_to :company, optional: true
      belongs_to :from_company, class_name: 'Company', optional: true
      belongs_to :to_company,   class_name: 'Company', optional: true
      belongs_to :project, optional: true
      has_many :billables,      dependent: :nullify
      has_many :invoice_items,  dependent: :destroy
      has_one :purchase # If the invoice is for a specific purchase

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

      responds_to_data_tables :id, :invoice_number, :reference, :invoice_date, :due_date, :status, :currency_code,
                              :total_amount, :amount_paid, :amount_due, :currency_rate,
                              company: [:name]

      store :plan_details, accessors: [ :plan_title, :plan_description, :plan_minimums, :plan_additionals, :plan_opening_balance, :plan_redeemed, :plan_issued, :plan_closing_balance ], coder: JSON, prefix: :plan

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
        self.currency_rate ||= CURRENCY_RATES[currency_code]
        self.managed_status ||= 'draft' if is_managed
      end

      before_save do
        if %w(DELETED VOIDED).include?(status)
          self.archived_at ||= DateTime.now
        end
      end

      after_save do
        if saved_change_to_archived_at?
          billables.update_all(archived_at: archived_at)
        end
      end

      scope :invoices,  -> { where(invoice_type: 'ACCREC') }
      scope :bills,     -> { where(invoice_type: 'ACCPAY') }
      scope :active,    -> { where.not(status: %w(DELETED VOIDED)) }
      scope :overdue,   -> { active.where('amount_due > 0').where('due_date < ?', Date.today) }
      scope :managed,   -> { where(is_managed: true) }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)
        if titles.include?(ROLE_INTERNAL_FINANCE)
          where(nil)

        else
          where('1=0')
        end
      end

      def self.for_selected_company(selected_company)
        if selected_company.nil?
          where(nil)
        else
          where(company_id: selected_company.id).or(where(to_company_id: selected_company.id)).or(where(from_company_id: selected_company.id))
        end
      end

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

      def display_billing_period(format = '%e %b %Y')
        if invoice_for_month.present?
          [
              invoice_for_month.at_beginning_of_month.strftime(format),
              invoice_for_month.at_end_of_month.strftime(format),
          ].join(' - ')
        else
          '&nbsp;'.html_safe
        end
      end

      def minimums(charge_attributes = plan_minimums)
        @minimums ||= Array(charge_attributes).map { |mm|
          Charge.new(*mm.values_at(:qty, :article_label, :base_amount, :discount_amount, :discount_type, :options))
        }
      end

      def minimums=(val)
        self.plan_minimums = Array(val).map(&:to_h)
      rescue StandardError
        self.plan_minimums = nil
      end

      def additionals
        @additionals ||= Array(plan_additionals).map { |mm|
          Charge.new(*mm.values_at(:qty, :article_label, :base_amount, :discount_amount, :discount_type))
        }
      end

      def additionals=(val)
        self.plan_additionals = Array(val).map(&:to_h)
      rescue StandardError
        self.plan_additionals = nil
      end

      def statement_number
        if purchase.nil?
          invoice_number
        else
          invoice_number.gsub('INV', 'REC')
        end
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

      def final_insp_pass_rate
        res = billables.map(&:quality_assurance_jobs).flatten.map(&:inspection).compact.select(&:inspection_type_is_final?).each_with_object([0.0, 0.0]) do |inspection, acc|
          acc[inspection.result_is_pass? ? 0 : 1] += inspection.po_qty
        end

        if res[0] + res[1] == 0
          1.0
        else
          res[0].to_f / (res[0] + res[1])
        end
      end

      def inspections(inspection_type = nil)
        @_inspections ||= billables.map(&:quality_assurance_jobs).flatten.map(&:inspection).compact

        if inspection_type.nil?
          @_inspections
        else
          @_inspections.select { |i| i.inspection_type == inspection_type.to_s }
        end
      end

      # === informative_item_per
      #
      # A method primarily used by form builder classes to re-use or build
      # new informative invoice items in a specific sequence.
      #
      def informative_item_per(description, attr = {})
        @matched_informatives ||= []

        # Match existing but not previously matched informative items
        item = invoice_items.detect do |invoice_item|
          !@matched_informatives.include?(invoice_item) && invoice_item.informative? && invoice_item.description == description
        end || invoice_items.informative.build(attr.merge(description: description))

        # Set attributes in case it was a previously existing item that should now have another line_item_order
        item.attributes = attr

        # Add to matched array so we don't re-assign the same one again
        @matched_informatives << item

        item
      end

      def update_stripe_ref!(type, ref = '')
        if (invoice_item = invoice_items.informative.detect { |ii| ii.description["#{type}:"] }).present?
          invoice_item.description = "#{type}: #{ref}"
          invoice_item.save!
        else
          next_line_item_order = (invoice_items.maximum(:line_item_order) || 0) + 1
          informative_item_per("#{type}: #{ref}", line_item_order: next_line_item_order).save!
        end
      end

      def self.from_params(params)
        active = ActiveRecord::Type::lookup(:boolean).cast(params.fetch(:active, true))
        archived = ActiveRecord::Type::lookup(:boolean).cast(params.fetch(:archived, true))

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
