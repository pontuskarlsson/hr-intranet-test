class CreateEmployeesXeroAccounts < ActiveRecord::Migration

  def up
    create_table :refinery_xero_accounts do |t|
      t.string :guid
      t.string :code
      t.string :name
      t.string :account_type
      t.string :account_class
      t.string :status
      t.string :currency_code
      t.string :tax_type
      t.string :description
      t.string :system_account
      t.boolean :enable_payments_account
      t.boolean :show_in_expense_claims
      t.string :bank_account_number
      t.string :reporting_code
      t.string :reporting_code_name

      t.timestamps
    end

    add_index :refinery_xero_accounts, :guid
  end

  def down
    remove_index :refinery_xero_accounts, :guid

    drop_table :refinery_xero_accounts

  end

end
