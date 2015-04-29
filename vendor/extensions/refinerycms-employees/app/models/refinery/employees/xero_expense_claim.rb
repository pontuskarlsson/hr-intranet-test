module Refinery
  module Employees
    class XeroExpenseClaim < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_expense_claims'

      STATUS_NOT_SUBMITTED  = 'NOT-SUBMITTED' # Not represented in Xero
      STATUS_SUBMITTED      = 'SUBMITTED'
      STATUS_AUTHORISED     = 'AUTHORISED'
      STATUS_PAID           = 'PAID'
      STATUS_DELETED        = 'DELETED'
      STATUSES = [STATUS_NOT_SUBMITTED, STATUS_SUBMITTED, STATUS_AUTHORISED, STATUS_PAID, STATUS_DELETED]

      belongs_to :added_by,                     class_name: '::Refinery::User'
      belongs_to :employee
      has_many :xero_receipts,                  dependent: :destroy
      has_many :xero_expense_claim_attachments, dependent: :destroy

      attr_accessible :guid, :status, :total, :amount_due, :amount_paid, :payment_due_date, :reporting_date, :updated_date_utc, :description, :employee_id

      validates :added_by_id,     presence: true
      validates :employee_id,     presence: true
      validates :status,          inclusion: STATUSES
      validates :description,     presence: true

      delegate :full_name, to: :employee, prefix: true

      before_validation do
        self.status ||= STATUS_NOT_SUBMITTED
      end

      # A Receipt is considered editable even when the status is deleted. The reason for
      # that is because if there was something wrong with the Expense Claim that was not
      # discovered until after it was approved, then it can be deleted from Xero, edited
      # here and then re-submitted again with minimum amount of work needed.
      def editable?
        (status == STATUS_NOT_SUBMITTED || status == STATUS_DELETED)
      end

      def submittable?
        editable? && xero_receipts.any? && employee.try(:xero_guid).present?
      end

      def submittable_by?(refinery_user)
        (employee.user_id == refinery_user.id || added_by_id == refinery_user.id) && submittable?
      end

      def destroyable_by?(refinery_user)
        editable?
      end

      def date
        updated_date_utc || updated_at
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

        def accessible_by_user(refinery_user)
          if refinery_user.employee.present?
            where('added_by_id = ? OR employee_id = ?', refinery_user.id, refinery_user.employee.id)
          else
            refinery_user.xero_expense_claims
          end
        end
      end

    end
  end
end
