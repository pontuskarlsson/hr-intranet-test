Refinery::Resource.class_eval do

  # Associations
  has_many :xero_expense_claim_attachments,
                class_name: '::Refinery::Employees::XeroExpenseClaimAttachment',
                dependent: :nullify

end
