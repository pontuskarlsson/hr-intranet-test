module Refinery
  module Employees
    class XeroExpenseClaim < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_expense_claims'

      STATUS_NOT_SUBMITTED  = 'NOT-SUBMITTED' # Not represented in Xero
      STATUS_SUBMITTED      = 'SUBMITTED'
      STATUS_AUTHORISED     = 'AUTHORISED'
      STATUS_PAID           = 'PAID'
      STATUSES = [STATUS_NOT_SUBMITTED, STATUS_SUBMITTED, STATUS_AUTHORISED, STATUS_PAID]

      belongs_to :employee
      has_many :xero_receipts,     dependent: :destroy
      has_many :xero_expense_claim_attachments, dependent: :destroy

      attr_accessible :guid, :status, :total, :amount_due, :amount_paid, :payment_due_date, :reporting_date, :updated_date_utc, :description

      validates :employee_id,     presence: true
      validates :status,          inclusion: STATUSES
      validates :description,     presence: true

      before_validation do
        self.status ||= STATUS_NOT_SUBMITTED
      end

      def submittable?
        status == STATUS_NOT_SUBMITTED and xero_receipts.any? && employee.try(:xero_guid).present?
      end

      class << self
        def not_submitted
          where(status: STATUS_NOT_SUBMITTED)
        end

        def submitted
          where(status: STATUS_SUBMITTED)
        end

        def authorised
          where(status: STATUS_AUTHORISED)
        end

        def paid
          where(status: STATUS_PAID)
        end

        def pending_in_xero
          where(status: [STATUS_SUBMITTED, STATUS_AUTHORISED]).includes(:xero_receipts)
        end
      end

    end
  end
end
