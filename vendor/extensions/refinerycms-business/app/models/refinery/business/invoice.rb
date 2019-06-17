module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

      belongs_to :account
      belongs_to :company
      belongs_to :project

      validates :account_id,    presence: true
      validates :invoice_id,    presence: true, uniqueness: true
      validates :contact_id,    presence: true
      validates :invoice_type,  inclusion: %w(ACCREC ACCPAY)
      validates :status,        inclusion: %w(DRAFT SUBMITTED DELETED AUTHORISED PAID VOIDED)

      scope :active, -> { where.not(status: %w(DELETED VOIDED)) }

      def display_total
        "#{total_amount} #{currency_code}"
      end

      def label
        invoice_number
      end

    end
  end
end
