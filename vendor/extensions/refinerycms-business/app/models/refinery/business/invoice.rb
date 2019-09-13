module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

      INVOICE_TYPES = %w(ACCREC ACCPAY)
      STATUSES = %w(DRAFT SUBMITTED DELETED AUTHORISED PAID VOIDED)

      belongs_to :account
      belongs_to :company
      belongs_to :project
      has_many :billables,      dependent: :nullify

      validates :account_id,    presence: true
      validates :invoice_id,    presence: true, uniqueness: true
      validates :contact_id,    presence: true
      validates :invoice_type,  inclusion: INVOICE_TYPES
      validates :status,        inclusion: STATUSES

      scope :active, -> { where.not(status: %w(DELETED VOIDED)) }
      scope :overdue, -> { active.where('amount_due > 0').where('due_date < ?', Date.today) }

      def display_total
        "#{total_amount} #{currency_code}"
      end

      def label
        invoice_number
      end

    end
  end
end
