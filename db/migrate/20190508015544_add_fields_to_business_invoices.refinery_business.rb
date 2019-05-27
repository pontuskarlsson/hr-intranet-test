# This migration comes from refinery_business (originally 13)
class AddFieldsToBusinessInvoices < ActiveRecord::Migration

  def up
    add_column :refinery_business_invoices, :company_id, :integer
    add_index :refinery_business_invoices, :company_id

    add_column :refinery_business_invoices, :project_id, :integer
    add_index :refinery_business_invoices, :project_id
  end

  def down
    remove_column :refinery_business_invoices, :project_id
    remove_column :refinery_business_invoices, :company_id
  end

end
