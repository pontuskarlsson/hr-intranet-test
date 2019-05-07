module Refinery
  module Business
    class Invoice < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_invoices'

      belongs_to :account

      validates :account_id,    presence: true
      validates :invoice_id,    presence: true, uniqueness: true
      validates :contact_id,    presence: true
      validates :invoice_type,  inclusion: %w(ACCREC ACCPAY)
      validates :status,        inclusion: %w(DRAFT SUBMITTED DELETED AUTHORISED PAID VOIDED)

    end
  end
end
