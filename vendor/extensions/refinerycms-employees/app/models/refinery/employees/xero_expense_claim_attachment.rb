module Refinery
  module Employees
    class XeroExpenseClaimAttachment < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_expense_claim_attachments'

      belongs_to :xero_expense_claim
      belongs_to :resource,     class_name: '::Refinery::Resource'

      attr_accessible :guid, :resource_id

      validates :xero_expense_claim_id, presence: true
      validates :resource_id,           presence: true, uniqueness: true
      validates :guid,                  uniqueness: true, allow_nil: true

    end
  end
end
