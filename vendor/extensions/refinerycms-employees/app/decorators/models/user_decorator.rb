Refinery::User.class_eval do

  # Associations
  has_one :employee,              class_name: '::Refinery::Employees::Employee', dependent: :nullify
  has_many :xero_expense_claims,  class_name: '::Refinery::Employees::XeroExpenseClaim', foreign_key: :added_by_id, dependent: :nullify

  # Method to retrieve all Expense Claims registered in Xero
  # for the current User.
  # def xero_expense_claims
  #   @xero_expense_claims ||= Refinery::Employees::XeroClient.client.ExpenseClaim.all(where: "User.EmailAddress.Contains(\"#{ email }\")", order: 'UpdatedDateUTC DESC')
  # end

  def employees_user_attribute
    send(Refinery::Employees.user_attribute_reference)
  end

end
