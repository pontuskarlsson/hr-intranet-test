class CreateEmployeesXeroExpenseClaimAttachments < ActiveRecord::Migration

  def change
    create_table :refinery_xero_expense_claim_attachments do |t|
      t.integer :xero_expense_claim_id
      t.integer :resource_id
      t.string :guid

      t.timestamps
    end

    add_index :refinery_xero_expense_claim_attachments, :xero_expense_claim_id, name: 'refinery_xeca_on_xero_expense_claim_id'
    add_index :refinery_xero_expense_claim_attachments, :resource_id,           name: 'refinery_xeca_on_resource_id'
    add_index :refinery_xero_expense_claim_attachments, :guid,                  name: 'refinery_xeca_on_guid'
  end

end
