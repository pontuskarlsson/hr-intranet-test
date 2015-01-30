Refinery::User.class_eval do

  # Associations
  has_one :employee, class_name: '::Refinery::Employees::Employee', dependent: :nullify

  # Method to retrieve all Expense Claims registered in Xero
  # for the current User.
  def xero_expense_claims
    @xero_expense_claims ||= ::XeroClient.client.ExpenseClaim.all(where: "User.EmailAddress.Contains(\"#{ email }\")", order: 'UpdatedDateUTC DESC')
  end

end
