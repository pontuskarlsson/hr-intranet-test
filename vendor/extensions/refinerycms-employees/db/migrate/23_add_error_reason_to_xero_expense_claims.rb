class AddErrorReasonToXeroExpenseClaims < ActiveRecord::Migration

  def change
    add_column :refinery_xero_expense_claims, :error_reason, :string
  end

end
