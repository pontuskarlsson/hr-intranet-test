class AddAddedByIdToEmployeesExpenseClaims < ActiveRecord::Migration

  def change
    add_column :refinery_xero_expense_claims, :added_by_id, :integer
    add_index :refinery_xero_expense_claims, :added_by_id
  end

end
